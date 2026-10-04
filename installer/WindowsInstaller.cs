using System;
using System.Diagnostics;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using Microsoft.Win32;

internal sealed class SetupManifest
{
    public string AppId;
    public string AppName;
    public string InstallFolder;
    public string Executable;
    public string Version;
    public string RegistryKey;
}

[ComImport, Guid("000214F9-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
internal interface IShellLinkW
{
    void GetPath([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder path, int length, IntPtr findData, uint flags);
    void GetIDList(out IntPtr idList);
    void SetIDList(IntPtr idList);
    void GetDescription([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder text, int length);
    void SetDescription([MarshalAs(UnmanagedType.LPWStr)] string text);
    void GetWorkingDirectory([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder path, int length);
    void SetWorkingDirectory([MarshalAs(UnmanagedType.LPWStr)] string path);
    void GetArguments([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder text, int length);
    void SetArguments([MarshalAs(UnmanagedType.LPWStr)] string text);
    void GetHotkey(out short hotkey);
    void SetHotkey(short hotkey);
    void GetShowCmd(out int command);
    void SetShowCmd(int command);
    void GetIconLocation([Out, MarshalAs(UnmanagedType.LPWStr)] StringBuilder path, int length, out int index);
    void SetIconLocation([MarshalAs(UnmanagedType.LPWStr)] string path, int index);
    void SetRelativePath([MarshalAs(UnmanagedType.LPWStr)] string path, uint reserved);
    void Resolve(IntPtr window, uint flags);
    void SetPath([MarshalAs(UnmanagedType.LPWStr)] string path);
}

[StructLayout(LayoutKind.Sequential, Pack = 4)]
internal struct PROPERTYKEY
{
    public Guid fmtid;
    public uint pid;
}

[StructLayout(LayoutKind.Explicit)]
internal struct PROPVARIANT
{
    [FieldOffset(0)] public ushort vt;
    [FieldOffset(8)] public IntPtr pwszVal;
}

[ComImport, Guid("886d8eeb-8cf2-4446-8d02-cdba1dbdcf99"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
internal interface IPropertyStore
{
    [PreserveSig] int GetCount(out uint cProps);
    [PreserveSig] int GetAt(uint iProp, out PROPERTYKEY pkey);
    [PreserveSig] int GetValue(ref PROPERTYKEY key, out PROPVARIANT pv);
    [PreserveSig] int SetValue(ref PROPERTYKEY key, ref PROPVARIANT pv);
    [PreserveSig] int Commit();
}

internal static class WindowsInstaller
{
    private const string PayloadResource = "TroLy.Payload.zip";
    private const string TermsResource = "TroLy.TERMS_VI.txt";
    private const string ManifestResource = "TroLy.SetupManifest.json";
    private const string LogoResource = "TroLy.Logo.png";
    private const string UninstallerResource = "TroLy.Uninstall.exe";
    private static SetupManifest manifest;
    private static string terms;
    private static bool integrationCheck = false;

    [DllImport("shell32.dll")]
    private static extern void SHChangeNotify(uint wEventId, uint uFlags, IntPtr dwItem1, IntPtr dwItem2);

    [STAThread]
    private static int Main(string[] args)
    {
        try
        {
            manifest = ReadManifest();
#if UNINSTALLER
            return RunUninstaller(args);
#else
            if (args.Contains("--integration-check"))
            {
                integrationCheck = true;
                return IntegrationCheck();
            }
            if (args.Any(a => String.Equals(a, "--self-check", StringComparison.OrdinalIgnoreCase)))
                return SelfCheck();
            if (args.Any(a => String.Equals(a, "--repair-shortcut", StringComparison.OrdinalIgnoreCase)))
                return RepairShortcut();
            if (args.Any(a => String.Equals(a, "--uninstall", StringComparison.OrdinalIgnoreCase)))
                return Uninstall();

            bool isFromTemp = false;
            try
            {
                string loc = Assembly.GetExecutingAssembly().Location;
                string tempDir = Path.GetTempPath().TrimEnd('\\', '/');
                isFromTemp = loc.StartsWith(tempDir, StringComparison.OrdinalIgnoreCase) ||
                             loc.IndexOf("Temp", StringComparison.OrdinalIgnoreCase) >= 0;
            }
            catch { }

            bool isAlreadyInstalled = false;
            try
            {
                isAlreadyInstalled = !string.IsNullOrEmpty(InstalledRoot());
            }
            catch { }

            if (args.Any(a => String.Equals(a, "--upgrade", StringComparison.OrdinalIgnoreCase) || String.Equals(a, "--silent", StringComparison.OrdinalIgnoreCase))
                || (isFromTemp && isAlreadyInstalled))
                return RunSilentUpgrade();

            terms = ReadTextResource(TermsResource);
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new SetupForm());
            return 0;
#endif
        }
        catch (Exception ex)
        {
            if (args.Length > 0 && (integrationCheck || args.Contains("--self-check") || args.Contains("--integration-uninstall")))
            {
                Console.Error.WriteLine(RootError(ex).ToString());
                if (IsIntegrationManifest()) File.WriteAllText(Path.Combine(CheckRoot(), "failure.txt"), RootError(ex).ToString());
                return 1;
            }
            MessageBox.Show("Không thể khởi chạy bộ cài đặt.\n\n" + RootError(ex).Message,
                "Lỗi cài đặt", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return 1;
        }
    }

    private static SetupManifest ReadManifest()
    {
        string json = ReadTextResource(ManifestResource);
        var result = new SetupManifest {
            AppId = ManifestValue(json, "app_id"), AppName = ManifestValue(json, "app_name"),
            InstallFolder = ManifestValue(json, "install_folder"), Executable = ManifestValue(json, "executable"),
            Version = ManifestValue(json, "version"), RegistryKey = ManifestValue(json, "registry_key")
        };
        if (!Regex.IsMatch(result.InstallFolder, "^[A-Za-z0-9_-]+$") ||
            !Regex.IsMatch(result.RegistryKey, "^[A-Za-z0-9_-]+$") ||
            result.Executable.Contains("..") || Path.IsPathRooted(result.Executable))
            throw new InvalidDataException("Cấu hình bộ cài chứa đường dẫn không hợp lệ.");
        return result;
    }

    private static string ManifestValue(string json, string key)
    {
        Match match = Regex.Match(json, "\"" + Regex.Escape(key) + "\"\\s*:\\s*\"((?:\\\\.|[^\"\\\\])*)\"");
        if (!match.Success) throw new InvalidDataException("Thiếu trường " + key + " trong cấu hình bộ cài.");
        return Regex.Unescape(match.Groups[1].Value);
    }

    private static string ReadTextResource(string name)
    {
        using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(name))
        {
            if (input == null) throw new FileNotFoundException("Không tìm thấy tài nguyên " + name);
            using (var reader = new StreamReader(input, new UTF8Encoding(false, true))) return reader.ReadToEnd();
        }
    }

    private static int SelfCheck()
    {
        using (Stream uninstaller = Assembly.GetExecutingAssembly().GetManifestResourceStream(UninstallerResource))
            if (uninstaller == null || uninstaller.Length == 0 || uninstaller.Length >= 1024 * 1024)
                throw new InvalidDataException("Thiếu trình gỡ cài đặt độc lập.");
        string license = ReadTextResource(TermsResource);
        if (String.IsNullOrWhiteSpace(license) || !license.Contains("đồng ý"))
            throw new InvalidDataException("Không tìm thấy điều khoản sử dụng tiếng Việt.");
        using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(PayloadResource))
        using (var zip = new ZipArchive(input, ZipArchiveMode.Read))
        {
            if (!zip.Entries.Any(e => String.Equals(e.FullName, manifest.Executable, StringComparison.OrdinalIgnoreCase)))
                throw new InvalidDataException("Payload thiếu tệp chạy " + manifest.Executable);
            if (zip.Entries.Count < 2) throw new InvalidDataException("Payload cài đặt rỗng.");
        }
        terms = license;
        using (var form = new SetupForm())
        {
            MethodInfo showPage = typeof(SetupForm).GetMethod("ShowPage", BindingFlags.Instance | BindingFlags.NonPublic);
            showPage.Invoke(form, new object[] { 1 });
            var accept = (CheckBox)typeof(SetupForm).GetField("accept", BindingFlags.Instance | BindingFlags.NonPublic).GetValue(form);
            var next = (Button)typeof(SetupForm).GetField("next", BindingFlags.Instance | BindingFlags.NonPublic).GetValue(form);
            if (accept.Checked || next.Enabled) throw new InvalidDataException("Nút tiếp tục phải khóa khi chưa đồng ý.");
            accept.Checked = true;
            if (!next.Enabled) throw new InvalidDataException("Nút tiếp tục chưa mở sau khi đồng ý.");
            accept.Checked = false;
            if (next.Enabled) throw new InvalidDataException("Nút tiếp tục vẫn mở sau khi bỏ đồng ý.");
        }
        using (Stream logo = Assembly.GetExecutingAssembly().GetManifestResourceStream(LogoResource))
        using (var image = new System.Drawing.Bitmap(logo))
            if (image.Width < 32 || image.Height < 32) throw new InvalidDataException("Logo bộ cài không hợp lệ.");
        string checkDirectory = Path.Combine(Path.GetTempPath(), "TroLySetupCheck-" + Guid.NewGuid().ToString("N"), "Kiểm tra tiếng Việt");
        string shortcutCheck = Path.Combine(checkDirectory, manifest.AppName + ".lnk");
        try
        {
            CreateShortcut(shortcutCheck, Assembly.GetExecutingAssembly().Location, Path.GetTempPath());
            if (!File.Exists(shortcutCheck)) throw new InvalidDataException("Windows không tạo được lối tắt kiểm tra.");
        }
        finally
        {
            if (File.Exists(shortcutCheck)) File.Delete(shortcutCheck);
            if (Directory.Exists(checkDirectory)) Directory.Delete(checkDirectory);
            if (Directory.Exists(Path.GetDirectoryName(checkDirectory))) Directory.Delete(Path.GetDirectoryName(checkDirectory));
        }
        Console.WriteLine("OK " + manifest.AppId + " " + manifest.Version + " " + manifest.Executable);
        return 0;
    }

    private static int RunSilentUpgrade()
    {
        try
        {
            string basePath;
            try
            {
                basePath = InstalledRoot();
            }
            catch
            {
                basePath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Programs", manifest.InstallFolder);
            }

            string versionPath = Path.Combine(basePath, "versions", manifest.Version);
            string staging = Path.Combine(basePath, ".install-" + Guid.NewGuid().ToString("N"));

            Directory.CreateDirectory(basePath);
            ValidateRoot(basePath);
            Directory.CreateDirectory(Path.GetDirectoryName(versionPath));

            string installedExe = Path.Combine(versionPath, manifest.Executable);

            // Chờ hoặc dọn dẹp các tiến trình cũ đang chạy để tránh xung đột khóa file và đóng cửa sổ giao diện cũ
            string versionsDir = Path.Combine(basePath, "versions") + Path.DirectorySeparatorChar;
            for (int wait = 0; wait < 10; wait++)
            {
                bool anyRunning = false;
                foreach (Process p in Process.GetProcesses())
                {
                    try
                    {
                        string fn = p.MainModule.FileName;
                        bool matchExe = fn.StartsWith(versionsDir, StringComparison.OrdinalIgnoreCase) ||
                            string.Equals(p.ProcessName, Path.GetFileNameWithoutExtension(manifest.Executable), StringComparison.OrdinalIgnoreCase);
                        bool matchTitle = !string.IsNullOrEmpty(p.MainWindowTitle) && p.MainWindowTitle.IndexOf(manifest.AppName, StringComparison.OrdinalIgnoreCase) >= 0;

                        if (matchExe || matchTitle)
                        {
                            anyRunning = true;
                            if (wait > 1)
                            {
                                p.Kill();
                            }
                        }
                    }
                    catch { }
                }
                if (!anyRunning) break;
                System.Threading.Thread.Sleep(500);
            }

            if (!Directory.Exists(versionPath) || !File.Exists(installedExe))
            {
                if (Directory.Exists(staging)) try { Directory.Delete(staging, true); } catch { }
                Directory.CreateDirectory(staging);
                using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(PayloadResource))
                using (var archive = new ZipArchive(input, ZipArchiveMode.Read))
                {
                    string root = Path.GetFullPath(staging) + Path.DirectorySeparatorChar;
                    foreach (ZipArchiveEntry entry in archive.Entries)
                    {
                        string target = Path.GetFullPath(Path.Combine(staging, entry.FullName.Replace('/', Path.DirectorySeparatorChar)));
                        if (!target.StartsWith(root, StringComparison.OrdinalIgnoreCase))
                            throw new InvalidDataException("Gói cài đặt chứa đường dẫn không hợp lệ.");
                        if (entry.FullName.EndsWith("/", StringComparison.Ordinal))
                        {
                            Directory.CreateDirectory(target);
                        }
                        else
                        {
                            Directory.CreateDirectory(Path.GetDirectoryName(target));
                            using (Stream source = entry.Open())
                            using (var output = new FileStream(target, FileMode.CreateNew, FileAccess.Write, FileShare.None))
                            {
                                source.CopyTo(output);
                            }
                        }
                    }
                }

                string appPath = Path.Combine(staging, manifest.Executable);
                if (!File.Exists(appPath)) throw new FileNotFoundException("Payload không có tệp chạy chính.");
                
                if (Directory.Exists(versionPath))
                {
                    try { Directory.Delete(versionPath, true); } catch { }
                }
                Directory.Move(staging, versionPath);
            }

            string uninstaller = EnsureRegistration(basePath);
            try
            {
                CreateShortcut(StartMenuLink(), installedExe, versionPath);
                CreateShortcut(UninstallMenuLink(), uninstaller, Path.GetDirectoryName(uninstaller));
                CreateShortcut(DesktopLink(), installedExe, versionPath);
            }
            catch { }

            if (File.Exists(installedExe))
            {
                Process.Start(new ProcessStartInfo
                {
                    FileName = installedExe,
                    WorkingDirectory = versionPath,
                    UseShellExecute = true
                });
            }

            return 0;
        }
        catch (Exception ex)
        {
            MessageBox.Show("Nâng cấp tự động thất bại:\n\n" + ex.Message, "Cập nhật ứng dụng", MessageBoxButtons.OK, MessageBoxIcon.Error);
            return 1;
        }
    }

    private sealed class SetupForm : Form
    {
        private readonly TextBox destination;
        private readonly CheckBox accept;
        private readonly Button next;
        private readonly Button back;
        private readonly Button cancel;
        private readonly CheckBox desktopShortcut;
        private readonly CheckBox launch;
        private readonly Panel content;
        private readonly Label pageHeading;
        private readonly Label pageHint;
        private readonly Label status;
        private readonly ProgressBar progress;
        private readonly Label[] steps;
        private int page;
        private string installedVersionPath;

        public string InstallForCheck(string basePath)
        {
            accept.Checked = true;
            desktopShortcut.Checked = true;
            destination.Text = basePath;
            Install();
            return installedVersionPath;
        }

        public SetupForm()
        {
            Text = "Cài đặt " + manifest.AppName;
            ClientSize = new System.Drawing.Size(820, 700); MinimumSize = new System.Drawing.Size(780, 650);
            StartPosition = FormStartPosition.CenterScreen;
            BackColor = System.Drawing.Color.FromArgb(244, 247, 251);
            Font = new System.Drawing.Font("Segoe UI", 9.5F);
            FormBorderStyle = FormBorderStyle.FixedDialog; MaximizeBox = false;

            var header = new Panel { Left = 0, Top = 0, Width = 820, Height = 108, BackColor = System.Drawing.Color.FromArgb(12, 43, 96), Anchor = AnchorStyles.Top | AnchorStyles.Left | AnchorStyles.Right };
            var logo = new PictureBox { Left = 24, Top = 17, Width = 74, Height = 74, SizeMode = PictureBoxSizeMode.Zoom, BackColor = System.Drawing.Color.FromArgb(12, 43, 96), Image = LoadLogo() };
            var brand = new Label { Left = 116, Top = 23, Width = 670, Height = 34, Text = manifest.AppName,
                ForeColor = System.Drawing.Color.White, Font = new System.Drawing.Font("Segoe UI", 17F, System.Drawing.FontStyle.Bold) };
            var subtitle = new Label { Left = 118, Top = 62, Width = 650, Height = 25,
                Text = "Bộ cài phiên bản " + manifest.Version + "  ·  Trợ lý giáo dục", ForeColor = System.Drawing.Color.FromArgb(210, 225, 247) };
            header.Controls.AddRange(new Control[] { logo, brand, subtitle });

            steps = new Label[4];
            string[] labels = { "Chào mừng", "Điều khoản", "Vị trí cài", "Hoàn tất" };
            for (int i = 0; i < labels.Length; i++)
                steps[i] = new Label { Left = 30 + i * 190, Top = 122, Width = 180, Height = 24, TextAlign = System.Drawing.ContentAlignment.MiddleLeft, Text = (i + 1).ToString("00") + "   " + labels[i] };

            content = new Panel { Left = 24, Top = 156, Width = 772, Height = 454, BackColor = System.Drawing.Color.White,
                BorderStyle = BorderStyle.FixedSingle, Anchor = AnchorStyles.Top | AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right };
            pageHeading = new Label { Left = 30, Top = 24, Width = 700, Height = 34, Font = new System.Drawing.Font("Segoe UI", 19F, System.Drawing.FontStyle.Bold), ForeColor = System.Drawing.Color.FromArgb(22, 42, 75) };
            pageHint = new Label { Left = 32, Top = 66, Width = 700, Height = 45, ForeColor = System.Drawing.Color.FromArgb(91, 107, 127), Font = new System.Drawing.Font("Segoe UI", 10F) };
            content.Controls.AddRange(new Control[] { pageHeading, pageHint });

            var footerLine = new Panel { Left = 0, Top = 628, Width = 820, Height = 1, BackColor = System.Drawing.Color.FromArgb(220, 226, 234), Anchor = AnchorStyles.Bottom | AnchorStyles.Left | AnchorStyles.Right };
            back = new Button { Left = 24, Top = 646, Width = 108, Height = 36, Text = "‹  Quay lại", FlatStyle = FlatStyle.Flat, BackColor = System.Drawing.Color.White, ForeColor = System.Drawing.Color.FromArgb(41, 58, 82), Anchor = AnchorStyles.Bottom | AnchorStyles.Left };
            back.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(205, 214, 226);
            cancel = new Button { Left = 564, Top = 646, Width = 104, Height = 36, Text = "Thoát", FlatStyle = FlatStyle.Flat, BackColor = System.Drawing.Color.White, ForeColor = System.Drawing.Color.FromArgb(41, 58, 82), Anchor = AnchorStyles.Bottom | AnchorStyles.Right };
            cancel.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(205, 214, 226);
            next = new Button { Left = 680, Top = 646, Width = 116, Height = 36, Text = "Tiếp theo  ›", FlatStyle = FlatStyle.Flat, BackColor = System.Drawing.Color.FromArgb(29, 105, 196), ForeColor = System.Drawing.Color.White, Anchor = AnchorStyles.Bottom | AnchorStyles.Right };
            next.FlatAppearance.BorderSize = 0;
            back.Click += (s, e) => ShowPage(page - 1);
            cancel.Click += (s, e) => Close();
            next.Click += NextClick;
            accept = new CheckBox();
            destination = new TextBox { ReadOnly = true };
            destination.Text = DefaultInstallBase();
            desktopShortcut = new CheckBox { Text = "Tạo lối tắt trên màn hình nền (Desktop)", Checked = true };
            launch = new CheckBox { Text = "Mở ứng dụng sau khi hoàn tất", Checked = true };
            progress = new ProgressBar { Style = ProgressBarStyle.Continuous, Minimum = 0, Maximum = 100 };
            status = new Label { ForeColor = System.Drawing.Color.FromArgb(91, 107, 127) };
            Controls.AddRange(new Control[] { header, footerLine, back, cancel, next, content });
            Controls.AddRange(steps);
            ShowPage(0);
        }

        private static System.Drawing.Image LoadLogo()
        {
            using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(LogoResource))
                return new System.Drawing.Bitmap(input);
        }

        private void ShowPage(int value)
        {
            page = Math.Max(0, Math.Min(3, value));
            foreach (Control control in content.Controls.Cast<Control>().Where(c => c != pageHeading && c != pageHint).ToArray())
            {
                content.Controls.Remove(control);
                if (control != destination && control != launch && control != desktopShortcut && control != accept && control != progress && control != status)
                    control.Dispose();
            }
            for (int i = 0; i < steps.Length; i++)
            {
                steps[i].ForeColor = i == page ? System.Drawing.Color.FromArgb(29, 105, 196) :
                    (i < page ? System.Drawing.Color.FromArgb(16, 124, 65) : System.Drawing.Color.FromArgb(130, 143, 160));
                steps[i].Font = new System.Drawing.Font("Segoe UI", 9F, i == page ? System.Drawing.FontStyle.Bold : System.Drawing.FontStyle.Regular);
            }
            back.Visible = page > 0 && page < 3;
            cancel.Visible = page < 3;
            next.Visible = true;
            next.Enabled = true;
            next.Text = page == 2 ? "Cài đặt" : page == 3 ? "Hoàn tất" : "Tiếp theo  ›";
            if (page == 0) ShowWelcome();
            else if (page == 1) ShowTerms();
            else if (page == 2) ShowLocation();
            else ShowComplete();
        }

        private bool IsExistingInstallation()
        {
            try
            {
                return !string.IsNullOrEmpty(InstalledRoot());
            }
            catch { return false; }
        }

        private void ShowWelcome()
        {
            if (IsExistingInstallation())
            {
                pageHeading.Text = "Nâng cấp " + manifest.AppName;
                pageHint.Text = "Phát hiện phiên bản cũ đã được cài đặt trên máy. Bấm 'Nâng cấp ngay' để cập nhật lên phiên bản " + manifest.Version + ".";
                next.Text = "Nâng cấp ngay  ›";
                var card = new Panel { Left = 32, Top = 128, Width = 704, Height = 186, BackColor = System.Drawing.Color.FromArgb(244, 248, 253) };
                var cardTitle = new Label { Left = 22, Top = 20, Width = 650, Height = 28, Text = "Nâng cấp an toàn & nhanh chóng", Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Bold), ForeColor = System.Drawing.Color.FromArgb(22, 42, 75) };
                var bullets = new Label { Left = 24, Top = 58, Width = 650, Height = 104,
                    Text = "✓  Nâng cấp lên phiên bản mới nhất " + manifest.Version + "\n✓  Bảo toàn 100% dữ liệu lớp học, hồ sơ trẻ và giáo án\n✓  Tự động cập nhật lối tắt và cấu hình hệ thống",
                    Font = new System.Drawing.Font("Segoe UI", 10F), ForeColor = System.Drawing.Color.FromArgb(52, 70, 94) };
                card.Controls.AddRange(new Control[] { cardTitle, bullets });
                var note = new Label { Left = 34, Top = 340, Width = 700, Height = 45,
                    Text = "Nhấn 'Nâng cấp ngay' bên dưới để tiến hành cập nhật trực tiếp.",
                    ForeColor = System.Drawing.Color.FromArgb(16, 124, 65), Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold) };
                content.Controls.AddRange(new Control[] { card, note });
                return;
            }

            pageHeading.Text = "Chào mừng bạn";
            pageHint.Text = "Cài đặt " + manifest.AppName + " trên máy tính này. Quá trình chỉ mất vài bước.";
            var welcomeCard = new Panel { Left = 32, Top = 128, Width = 704, Height = 186, BackColor = System.Drawing.Color.FromArgb(244, 248, 253) };
            var welcomeCardTitle = new Label { Left = 22, Top = 20, Width = 650, Height = 28, Text = "Trong bộ cài này có", Font = new System.Drawing.Font("Segoe UI", 11F, System.Drawing.FontStyle.Bold), ForeColor = System.Drawing.Color.FromArgb(22, 42, 75) };
            var welcomeBullets = new Label { Left = 24, Top = 58, Width = 650, Height = 104,
                Text = "✓  Ứng dụng và các thành phần cần thiết\n✓  Cài đặt theo từng phiên bản, không ghi đè ứng dụng đang chạy\n✓  Trình gỡ cài đặt riêng; dữ liệu công việc được giữ nguyên",
                Font = new System.Drawing.Font("Segoe UI", 10F), ForeColor = System.Drawing.Color.FromArgb(52, 70, 94) };
            welcomeCard.Controls.AddRange(new Control[] { welcomeCardTitle, welcomeBullets });
            var welcomeNote = new Label { Left = 34, Top = 340, Width = 700, Height = 45,
                Text = "Ở bước tiếp theo, bạn sẽ xem Điều khoản sử dụng. Bạn cần đồng ý trước khi cài đặt.",
                ForeColor = System.Drawing.Color.FromArgb(91, 107, 127), Font = new System.Drawing.Font("Segoe UI", 9.5F) };
            content.Controls.AddRange(new Control[] { welcomeCard, welcomeNote });
        }

        private void ShowTerms()
        {
            pageHeading.Text = "Điều khoản sử dụng";
            pageHint.Text = "Vui lòng đọc điều khoản trước khi tiếp tục cài đặt.";
            var license = new RichTextBox { Left = 32, Top = 112, Width = 704, Height = 258,
                ReadOnly = true, DetectUrls = false, WordWrap = true, ScrollBars = RichTextBoxScrollBars.Vertical,
                BorderStyle = BorderStyle.FixedSingle, BackColor = System.Drawing.Color.White, Text = terms,
                Font = new System.Drawing.Font("Segoe UI", 9.2F) };
            accept.SetBounds(32, 386, 704, 30);
            accept.Text = "Tôi đã đọc và đồng ý với Điều khoản sử dụng.";
            accept.Font = new System.Drawing.Font("Segoe UI", 9.5F, System.Drawing.FontStyle.Bold);
            accept.ForeColor = System.Drawing.Color.FromArgb(22, 42, 75);
            accept.CheckedChanged -= AcceptanceChanged;
            accept.CheckedChanged += AcceptanceChanged;
            content.Controls.AddRange(new Control[] { license, accept });
            next.Enabled = accept.Checked;
        }

        private void ShowLocation()
        {
            pageHeading.Text = "Chọn vị trí cài đặt";
            pageHint.Text = "Ứng dụng được cài cho tài khoản Windows hiện tại, không cần quyền quản trị.";
            var pathTitle = new Label { Left = 32, Top = 124, Width = 690, Height = 24, Text = "Thư mục chương trình", Font = new System.Drawing.Font("Segoe UI", 10F, System.Drawing.FontStyle.Bold), ForeColor = System.Drawing.Color.FromArgb(22, 42, 75) };
            destination.SetBounds(32, 154, 570, 34); destination.Font = new System.Drawing.Font("Segoe UI", 9.5F);
            var browse = new Button { Left = 614, Top = 152, Width = 122, Height = 36, Text = "Chọn thư mục…", FlatStyle = FlatStyle.Flat, BackColor = System.Drawing.Color.FromArgb(244, 247, 251) };
            browse.FlatAppearance.BorderColor = System.Drawing.Color.FromArgb(205, 214, 226);
            browse.Click += (s, e) => Browse();
            desktopShortcut.SetBounds(32, 202, 690, 26); desktopShortcut.Font = new System.Drawing.Font("Segoe UI", 9.5F); desktopShortcut.ForeColor = System.Drawing.Color.FromArgb(52, 70, 94);
            launch.SetBounds(32, 234, 690, 26); launch.Font = new System.Drawing.Font("Segoe UI", 9.5F); launch.ForeColor = System.Drawing.Color.FromArgb(52, 70, 94);
            var dataNote = new Label { Left = 32, Top = 276, Width = 690, Height = 76,
                Text = "Thư mục cài đặt: " + manifest.InstallFolder + "\\versions\\" + manifest.Version + "\nDữ liệu cá nhân được lưu riêng và không bị xóa khi gỡ chương trình.",
                ForeColor = System.Drawing.Color.FromArgb(91, 107, 127), Font = new System.Drawing.Font("Segoe UI", 9.5F) };
            content.Controls.AddRange(new Control[] { pathTitle, destination, browse, desktopShortcut, launch, dataNote });
        }

        private void ShowComplete()
        {
            pageHeading.Text = "Cài đặt hoàn tất";
            pageHint.Text = manifest.AppName + " phiên bản " + manifest.Version + " đã được cài đặt thành công.";
            var success = new Label { Left = 34, Top = 142, Width = 700, Height = 90, Text = "✓",
                TextAlign = System.Drawing.ContentAlignment.MiddleCenter, ForeColor = System.Drawing.Color.FromArgb(16, 124, 65),
                Font = new System.Drawing.Font("Segoe UI", 48F, System.Drawing.FontStyle.Bold) };
            var path = new Label { Left = 48, Top = 248, Width = 676, Height = 52,
                Text = "Đã cài tại:\n" + installedVersionPath, TextAlign = System.Drawing.ContentAlignment.MiddleCenter,
                ForeColor = System.Drawing.Color.FromArgb(52, 70, 94), Font = new System.Drawing.Font("Segoe UI", 9.5F) };
            launch.SetBounds(205, 328, 370, 30);
            content.Controls.AddRange(new Control[] { success, path, launch });
        }

        private void AcceptanceChanged(object sender, EventArgs e)
        {
            if (page == 1) next.Enabled = accept.Checked;
        }

        private void NextClick(object sender, EventArgs e) { Next(); }

        private void FinishClick(object sender, EventArgs e)
        {
            if (launch.Checked && !String.IsNullOrEmpty(installedVersionPath))
            {
                string executable = Path.Combine(installedVersionPath, manifest.Executable);
                Process.Start(new ProcessStartInfo(executable) { WorkingDirectory = installedVersionPath, UseShellExecute = true });
            }
            Close();
        }

        private void Next()
        {
            if (page == 0)
            {
                if (IsExistingInstallation())
                {
                    accept.Checked = true;
                    Install();
                    return;
                }
                ShowPage(1);
            }
            else if (page == 1 && accept.Checked) ShowPage(2);
            else if (page == 2) Install();
            else if (page == 3) FinishClick(this, EventArgs.Empty);
        }

        private string DefaultInstallBase()
        {
            using (RegistryKey key = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Uninstall\" + manifest.RegistryKey))
            {
                string prior = key == null ? null : key.GetValue("InstallLocation") as string;
                if (!String.IsNullOrWhiteSpace(prior) && Path.GetFileName(prior.TrimEnd(Path.DirectorySeparatorChar)) == manifest.InstallFolder)
                    return prior;
            }
            return Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Programs", manifest.InstallFolder);
        }

        private void Browse()
        {
            using (var dialog = new FolderBrowserDialog { Description = "Chọn thư mục cha để cài " + manifest.AppName,
                SelectedPath = Directory.GetParent(destination.Text).FullName, ShowNewFolderButton = true })
            {
                if (dialog.ShowDialog(this) == DialogResult.OK)
                    destination.Text = Path.Combine(dialog.SelectedPath, manifest.InstallFolder);
            }
        }

        private void Install()
        {
            try
            {
                using (var guard = MaintenanceLock())
                {
                    try { InstallCore(); } finally { guard.ReleaseMutex(); }
                }
            }
            catch (Exception ex)
            {
                if (integrationCheck) throw;
                next.Enabled = accept.Checked; back.Enabled = true; cancel.Enabled = true;
                MessageBox.Show(this, RootError(ex).Message, Text, MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void InstallCore()
        {
            if (!accept.Checked)
            {
                MessageBox.Show(this, "Bạn cần đồng ý với Điều khoản sử dụng trước khi cài đặt.", Text,
                    MessageBoxButtons.OK, MessageBoxIcon.Information); return;
            }
            next.Enabled = false; back.Enabled = false; cancel.Enabled = false;
            string basePath = Path.GetFullPath(destination.Text);
            if (Path.GetFileName(basePath.TrimEnd(Path.DirectorySeparatorChar)) != manifest.InstallFolder ||
                Path.GetPathRoot(basePath).TrimEnd(Path.DirectorySeparatorChar) == basePath.TrimEnd(Path.DirectorySeparatorChar))
            {
                next.Enabled = true; back.Enabled = true; cancel.Enabled = true;
                MessageBox.Show(this, "Thư mục cài đặt không hợp lệ. Hãy chọn một thư mục cha khác.", Text,
                    MessageBoxButtons.OK, MessageBoxIcon.Warning); return;
            }
            string versionPath = Path.Combine(basePath, "versions", manifest.Version);
            string staging = Path.Combine(basePath, ".install-" + Guid.NewGuid().ToString("N"));
            bool moved = false;
            try
            {
                ShowProgress();
                Directory.CreateDirectory(basePath);
                ValidateRoot(basePath);
                Directory.CreateDirectory(Path.GetDirectoryName(versionPath));
                if (Directory.Exists(versionPath))
                {
                    string existingExe = Path.GetFullPath(Path.Combine(versionPath, manifest.Executable));
                    if (!File.Exists(existingExe)) throw new IOException("Bản cài hiện có thiếu tệp chạy chính: " + existingExe);
                    string repairedUninstaller = EnsureRegistration(basePath);
                    CreateShortcut(StartMenuLink(), existingExe, versionPath);
                    CreateShortcut(UninstallMenuLink(), repairedUninstaller, Path.GetDirectoryName(repairedUninstaller));
                    if (desktopShortcut.Checked)
                    {
                        CreateShortcut(DesktopLink(), existingExe, versionPath);
                    }
                    installedVersionPath = versionPath;
                    ShowPage(3);
                    return;
                }
                Directory.CreateDirectory(staging);
                using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(PayloadResource))
                using (var archive = new ZipArchive(input, ZipArchiveMode.Read))
                {
                    string root = Path.GetFullPath(staging) + Path.DirectorySeparatorChar;
                    ZipArchiveEntry[] entries = archive.Entries.Cast<ZipArchiveEntry>().ToArray();
                    progress.Maximum = Math.Max(1, entries.Length); progress.Value = 0;
                    foreach (ZipArchiveEntry entry in entries)
                    {
                        string target = Path.GetFullPath(Path.Combine(staging, entry.FullName.Replace('/', Path.DirectorySeparatorChar)));
                        if (!target.StartsWith(root, StringComparison.OrdinalIgnoreCase))
                            throw new InvalidDataException("Gói cài đặt chứa đường dẫn không hợp lệ.");
                        if (entry.FullName.EndsWith("/", StringComparison.Ordinal)) Directory.CreateDirectory(target);
                        else
                        {
                            Directory.CreateDirectory(Path.GetDirectoryName(target));
                            using (Stream source = entry.Open())
                            using (var output = new FileStream(target, FileMode.CreateNew, FileAccess.Write, FileShare.None)) source.CopyTo(output);
                        }
                        progress.Value = Math.Min(progress.Maximum, progress.Value + 1);
                        status.Text = "Đang giải nén " + Path.GetFileName(entry.FullName);
                        progress.Refresh(); status.Refresh();
                    }
                }
                string appPath = Path.Combine(staging, manifest.Executable);
                if (!File.Exists(appPath)) throw new FileNotFoundException("Payload không có tệp chạy chính.");
                Directory.Move(staging, versionPath); moved = true;
                string installedExe = Path.Combine(versionPath, manifest.Executable);
                string uninstaller = EnsureRegistration(basePath);
                installedVersionPath = versionPath;
                ShowPage(3);
                try
                {
                    CreateShortcut(StartMenuLink(), installedExe, versionPath);
                    CreateShortcut(UninstallMenuLink(), uninstaller, Path.GetDirectoryName(uninstaller));
                    if (desktopShortcut.Checked)
                    {
                        CreateShortcut(DesktopLink(), installedExe, versionPath);
                    }
                }
                catch (Exception shortcutError)
                {
                    if (integrationCheck) throw;
                    MessageBox.Show(this, "Ứng dụng đã được cài đặt, nhưng Windows không tạo được lối tắt. Bạn có thể mở trực tiếp:\n\n" + installedExe + "\n\nChi tiết: " + RootError(shortcutError).Message,
                        Text, MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
            }
            catch (Exception ex)
            {
                if (Directory.Exists(staging)) try { Directory.Delete(staging, true); } catch { }
                if (moved && Directory.Exists(versionPath)) try { Directory.Delete(versionPath, true); } catch { }
                if (integrationCheck) throw;
                next.Enabled = accept.Checked; back.Enabled = true; cancel.Enabled = true;
                ShowPage(2);
                MessageBox.Show(this, "Không thể hoàn tất cài đặt.\n\n" + RootError(ex).Message, Text,
                    MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void ShowProgress()
        {
            foreach (Control control in content.Controls.Cast<Control>().Where(c => c != pageHeading && c != pageHint).ToArray())
            {
                content.Controls.Remove(control);
                if (control != destination && control != launch && control != desktopShortcut && control != accept && control != progress && control != status)
                    control.Dispose();
            }
            pageHeading.Text = "Đang cài đặt";
            pageHint.Text = "Vui lòng đợi trong khi chúng tôi sao chép các thành phần cần thiết.";
            progress.SetBounds(42, 204, 688, 24);
            status.SetBounds(42, 244, 688, 30); status.Text = "Đang chuẩn bị bộ cài…";
            content.Controls.AddRange(new Control[] { progress, status });
            back.Visible = false; next.Visible = false; cancel.Visible = false;
            Application.DoEvents();
        }
    }

    private static void RegisterInstall(string basePath, string uninstaller)
    {
        using (RegistryKey key = Registry.CurrentUser.CreateSubKey(@"Software\Microsoft\Windows\CurrentVersion\Uninstall\" + manifest.RegistryKey))
        {
            key.SetValue("DisplayName", manifest.AppName, RegistryValueKind.String);
            key.SetValue("DisplayVersion", manifest.Version, RegistryValueKind.String);
            key.SetValue("InstallLocation", basePath, RegistryValueKind.String);
            key.SetValue("UninstallString", "\"" + uninstaller + "\" --uninstall", RegistryValueKind.String);
            key.SetValue("NoModify", 1, RegistryValueKind.DWord);
            key.SetValue("NoRepair", 1, RegistryValueKind.DWord);
            key.SetValue("DisplayIcon", Path.GetFullPath(Path.Combine(basePath, "versions", manifest.Version, manifest.Executable)), RegistryValueKind.String);
        }
    }

    private static string RegistryPath()
    {
        return @"Software\Microsoft\Windows\CurrentVersion\Uninstall\" + manifest.RegistryKey;
    }

    private static System.Threading.Mutex MaintenanceLock()
    {
        var mutex = new System.Threading.Mutex(false, @"Local\TroLyMaintenance-" + manifest.RegistryKey);
        bool acquired;
        try { acquired = mutex.WaitOne(0); }
        catch (System.Threading.AbandonedMutexException) { acquired = true; }
        if (!acquired)
        {
            mutex.Dispose();
            throw new IOException("Một tiến trình cài đặt hoặc gỡ cài đặt đang hoạt động. Hãy chờ tiến trình đó hoàn tất.");
        }
        return mutex;
    }

    private static string EnsureRegistration(string basePath)
    {
        ValidateRoot(basePath);
        string folder = Path.Combine(basePath, ".maintenance", Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(folder);
        string uninstaller = Path.Combine(folder, "Uninstall.exe");
        try
        {
            using (Stream input = Assembly.GetExecutingAssembly().GetManifestResourceStream(UninstallerResource))
            using (var output = new FileStream(uninstaller, FileMode.CreateNew, FileAccess.Write))
            {
                if (input == null) throw new InvalidDataException("Bộ cài thiếu trình gỡ cài đặt.");
                input.CopyTo(output);
            }
            File.WriteAllText(Path.Combine(basePath, ".troly-install"), manifest.AppId + "\n" + manifest.InstallFolder, Encoding.UTF8);
            RegisterInstall(basePath, uninstaller);
            return uninstaller;
        }
        catch
        {
            if (File.Exists(uninstaller)) File.Delete(uninstaller);
            if (Directory.Exists(folder)) Directory.Delete(folder);
            throw;
        }
    }

    private static string StripDiacritics(string text)
    {
        string normalized = text.Normalize(NormalizationForm.FormD);
        var sb = new StringBuilder();
        foreach (char c in normalized)
        {
            if (c == 'Đ') sb.Append('D');
            else if (c == 'đ') sb.Append('d');
            else if (System.Globalization.CharUnicodeInfo.GetUnicodeCategory(c) != System.Globalization.UnicodeCategory.NonSpacingMark)
                sb.Append(c);
        }
        return sb.ToString().Normalize(NormalizationForm.FormC);
    }

    private static void CreateShortcut(string linkPath, string targetPath, string workingDirectory)
    {
        Directory.CreateDirectory(Path.GetDirectoryName(linkPath));
        object shortcut = Activator.CreateInstance(Type.GetTypeFromCLSID(new Guid("00021401-0000-0000-C000-000000000046")));
        try
        {
            var link = (IShellLinkW)shortcut;
            string target = Path.GetFullPath(targetPath);
            link.SetPath(target);
            link.SetWorkingDirectory(Path.GetFullPath(workingDirectory));

            string targetDir = Path.GetDirectoryName(target);
            string ico = Path.Combine(targetDir, "_internal", "wpf", "icon.ico");
            if (!File.Exists(ico))
                ico = Path.Combine(targetDir, "wpf", "icon.ico");
            if (!File.Exists(ico))
                ico = Path.Combine(targetDir, "icon.ico");
            if (!File.Exists(ico))
                ico = Path.Combine(workingDirectory, "wpf", "icon.ico");
            if (!File.Exists(ico))
                ico = Path.Combine(workingDirectory, "icon.ico");
            if (File.Exists(ico))
                link.SetIconLocation(ico, 0);
            else
                link.SetIconLocation(target, 0);

            try
            {
                var store = shortcut as IPropertyStore;
                if (store != null)
                {
                    var pkey = new PROPERTYKEY
                    {
                        fmtid = new Guid("9F4C2855-9F79-4B39-A8D0-E1D42DE1D5F3"),
                        pid = 5
                    };
                    string appId = "TroLyGiaoDuc.MamNon.Desktop";
                    if (manifest != null)
                    {
                        if (manifest.AppId == "teacher") appId = "TroLyGiaoDuc.GiaoVien.Desktop";
                        else if (manifest.AppId == "school") appId = "TroLyGiaoDuc.QuanTriTruongHoc.Desktop";
                        else if (manifest.AppId == "specialist") appId = "TroLyGiaoDuc.ChuyenVien.Desktop";
                    }
                    var pv = new PROPVARIANT
                    {
                        vt = 31, // VT_LPWSTR
                        pwszVal = Marshal.StringToCoTaskMemUni(appId)
                    };
                    store.SetValue(ref pkey, ref pv);
                    store.Commit();
                    Marshal.FreeCoTaskMem(pv.pwszVal);
                }
            }
            catch { }

            var persistent = (System.Runtime.InteropServices.ComTypes.IPersistFile)shortcut;
            try
            {
                persistent.Save(Path.GetFullPath(linkPath), true);
            }
            catch
            {
                string dir = Path.GetDirectoryName(linkPath);
                string filename = Path.GetFileNameWithoutExtension(linkPath);
                string ext = Path.GetExtension(linkPath);
                string cleanName = StripDiacritics(filename);
                linkPath = Path.Combine(dir, cleanName + ext);
                persistent.Save(Path.GetFullPath(linkPath), true);
            }
            try { SHChangeNotify(0x08000000, 0, IntPtr.Zero, IntPtr.Zero); } catch { }
            persistent.Load(Path.GetFullPath(linkPath), 0);
            var actual = new StringBuilder(32768);
            link.GetPath(actual, actual.Capacity, IntPtr.Zero, 4);
            if (!String.Equals(actual.ToString(), target, StringComparison.OrdinalIgnoreCase))
                throw new IOException("Lối tắt không trỏ đúng tệp ứng dụng.");
        }
        finally
        {
            if (shortcut != null && Marshal.IsComObject(shortcut)) Marshal.ReleaseComObject(shortcut);
        }
    }

    private static string StartMenuLink()
    {
        string link = Path.Combine(MenuDirectory(), manifest.AppName + ".lnk");
        if (!File.Exists(link))
        {
            string fallback = Path.Combine(MenuDirectory(), StripDiacritics(manifest.AppName) + ".lnk");
            if (File.Exists(fallback)) return fallback;
        }
        return link;
    }

    private static string UninstallMenuLink()
    {
        string link = Path.Combine(MenuDirectory(), "Gỡ " + manifest.AppName + ".lnk");
        if (!File.Exists(link))
        {
            string fallback = Path.Combine(MenuDirectory(), "Go " + StripDiacritics(manifest.AppName) + ".lnk");
            if (File.Exists(fallback)) return fallback;
        }
        return link;
    }

    private static string DesktopDirectory()
    {
        return IsIntegrationManifest() ? Path.Combine(CheckRoot(), "Desktop") : Environment.GetFolderPath(Environment.SpecialFolder.DesktopDirectory);
    }

    private static string DesktopLink()
    {
        string link = Path.Combine(DesktopDirectory(), manifest.AppName + ".lnk");
        if (!File.Exists(link))
        {
            string fallback = Path.Combine(DesktopDirectory(), StripDiacritics(manifest.AppName) + ".lnk");
            if (File.Exists(fallback)) return fallback;
        }
        return link;
    }

    private static bool IsIntegrationManifest() { return manifest != null && manifest.RegistryKey.Contains("-InstallTest-"); }
    private static string CheckRoot() { return Path.Combine(Path.GetTempPath(), "TLI-" + manifest.RegistryKey.Substring(manifest.RegistryKey.Length - 8)); }
    private static string MenuDirectory()
    {
        return IsIntegrationManifest() ? Path.Combine(CheckRoot(), "StartMenu") : Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.StartMenu), "Programs");
    }

    private static void ValidateRoot(string path)
    {
        string full = Path.GetFullPath(path).TrimEnd(Path.DirectorySeparatorChar);
        if (Path.GetFileName(full) != manifest.InstallFolder || full == Path.GetPathRoot(full).TrimEnd(Path.DirectorySeparatorChar))
            throw new InvalidDataException("Thư mục cài đặt không hợp lệ.");
        for (var dir = new DirectoryInfo(full); dir != null; dir = dir.Parent)
            if (dir.Exists && (dir.Attributes & FileAttributes.ReparsePoint) != 0)
                throw new IOException("Không xử lý thư mục cài đặt thông qua liên kết thư mục: " + dir.FullName);
    }

    private static string InstalledRoot()
    {
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath()))
        {
            string root = key == null ? null : key.GetValue("InstallLocation") as string;
            if (String.IsNullOrWhiteSpace(root)) throw new IOException("Chưa tìm thấy thông tin ứng dụng đã cài.");
            ValidateRoot(root);
            string marker = Path.Combine(root, ".troly-install");
            if (!File.Exists(marker) || File.ReadAllText(marker, Encoding.UTF8) != manifest.AppId + "\n" + manifest.InstallFolder)
                throw new IOException("Chưa xác nhận được thư mục ứng dụng. Hãy chạy bộ cài mới để sửa thông tin cài đặt.");
            return Path.GetFullPath(root);
        }
    }

    private static int RepairShortcut()
    {
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Uninstall\" + manifest.RegistryKey))
        {
            string location = key == null ? null : key.GetValue("InstallLocation") as string;
            if (String.IsNullOrWhiteSpace(location)) throw new IOException("Chưa tìm thấy ứng dụng đã cài đặt.");
            string versionPath = Path.Combine(location, "versions", manifest.Version);
            string executable = Path.GetFullPath(Path.Combine(versionPath, manifest.Executable));
            if (!File.Exists(executable)) throw new FileNotFoundException("Không tìm thấy ứng dụng đã cài.", executable);
            CreateShortcut(StartMenuLink(), executable, versionPath);
            CreateShortcut(DesktopLink(), executable, versionPath);
            Console.WriteLine("Shortcut repaired: " + StartMenuLink());
            return 0;
        }
    }

    private static Exception RootError(Exception error)
    {
        while ((error is TargetInvocationException || error is AggregateException) && error.InnerException != null)
            error = error.InnerException;
        return error;
    }

    private static int Uninstall()
    {
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath()))
        {
            string basePath = key == null ? null : key.GetValue("InstallLocation") as string;
            if (String.IsNullOrWhiteSpace(basePath)) throw new IOException("Chưa tìm thấy ứng dụng đã cài.");
            string uninstaller = EnsureRegistration(basePath);
            Process.Start(new ProcessStartInfo(uninstaller) { UseShellExecute = false });
        }
        return 0;
    }

    private static void CheckRunningApps(string root)
    {
        string prefix = Path.GetFullPath(Path.Combine(root, "versions")) + Path.DirectorySeparatorChar;
        foreach (Process process in Process.GetProcesses())
        {
            using (process)
            {
                string file;
                try { file = process.MainModule.FileName; } catch { continue; }
                if (file.StartsWith(prefix, StringComparison.OrdinalIgnoreCase))
                    throw new IOException("Ứng dụng đang chạy. Hãy đóng ứng dụng rồi gỡ cài đặt lại.");
            }
        }
    }

    private static void AssertNoLinks(string directory)
    {
        if (!Directory.Exists(directory)) return;
        if ((File.GetAttributes(directory) & FileAttributes.ReparsePoint) != 0)
            throw new IOException("Không xóa thư mục liên kết: " + directory);
        foreach (string child in Directory.GetDirectories(directory)) AssertNoLinks(child);
        foreach (string file in Directory.GetFiles(directory))
            if ((File.GetAttributes(file) & FileAttributes.ReparsePoint) != 0)
                throw new IOException("Không xóa tệp liên kết: " + file);
    }

    private static string RemoveInstallation(string root)
    {
        if (!String.Equals(InstalledRoot(), Path.GetFullPath(root), StringComparison.OrdinalIgnoreCase))
            throw new IOException("Thông tin cài đặt đã thay đổi.");
        CheckRunningApps(root);
        string versions = Path.Combine(root, "versions");
        string maintenance = Path.Combine(root, ".maintenance");
        AssertNoLinks(versions);
        AssertNoLinks(maintenance);
        if (Directory.Exists(versions)) Directory.Delete(versions, true);
        if (File.Exists(StartMenuLink())) File.Delete(StartMenuLink());
        if (File.Exists(UninstallMenuLink())) File.Delete(UninstallMenuLink());
        try { if (File.Exists(DesktopLink())) File.Delete(DesktopLink()); } catch { }
        try
        {
            string cleanDesk = Path.Combine(DesktopDirectory(), StripDiacritics(manifest.AppName) + ".lnk");
            if (File.Exists(cleanDesk)) File.Delete(cleanDesk);
        } catch { }
        using (RegistryKey parent = Registry.CurrentUser.OpenSubKey(@"Software\Microsoft\Windows\CurrentVersion\Uninstall", true))
            if (parent != null) parent.DeleteSubKeyTree(manifest.RegistryKey, false);
        string warning = "";
        try { if (Directory.Exists(maintenance)) Directory.Delete(maintenance, true); }
        catch (IOException ex) { warning = ex.Message; }
        catch (UnauthorizedAccessException ex) { warning = ex.Message; }
        // Legacy setups used one fixed root-level executable; it may be locked or blocked.
        // Its cleanup is not a prerequisite for removing the application's actual files.
        try { File.Delete(Path.Combine(root, "Uninstall-" + manifest.InstallFolder + ".exe")); }
        catch (IOException ex) { warning = ex.Message; }
        catch (UnauthorizedAccessException ex) { warning = ex.Message; }
        File.Delete(Path.Combine(root, ".troly-install"));
        if (!Directory.EnumerateFileSystemEntries(root).Any()) Directory.Delete(root);
        return warning;
    }

    private static int RunUninstaller(string[] args)
    {
        bool test = args.Contains("--integration-uninstall");
        if (test && !IsIntegrationManifest()) throw new InvalidOperationException("Chế độ thử chỉ dùng cho bộ cài thử nghiệm.");
        bool worker = args.Length >= 2 && args[0] == "--worker";
        if (worker)
        {
            int parentId = Int32.Parse(args[1]);
            try
            {
                using (Process parent = Process.GetProcessById(parentId))
                    if (!parent.WaitForExit(30000)) throw new IOException("Trình gỡ cài đặt trước chưa đóng.");
            }
            catch (ArgumentException) { }
            string warning;
            using (var guard = MaintenanceLock())
            {
                try { warning = RemoveInstallation(InstalledRoot()); }
                finally { guard.ReleaseMutex(); }
            }
            if (test) File.WriteAllText(Path.Combine(CheckRoot(), "uninstall-result.txt"), "PASS\n" + warning);
            else MessageBox.Show("Đã gỡ " + manifest.AppName + ".\nDữ liệu cá nhân được giữ lại." +
                (warning.Length == 0 ? "" : "\n\nMột số tệp cũ vẫn bị Windows chặn xóa:\n" + warning), "Gỡ cài đặt",
                MessageBoxButtons.OK, warning.Length == 0 ? MessageBoxIcon.Information : MessageBoxIcon.Warning);
            return 0;
        }
        string root = InstalledRoot();
        CheckRunningApps(root);
        if (!test && MessageBox.Show("Gỡ " + manifest.AppName + " khỏi máy tính?\nDữ liệu cá nhân được giữ lại.",
                "Gỡ cài đặt", MessageBoxButtons.YesNo, MessageBoxIcon.Question) != DialogResult.Yes) return 0;
        string workerDirectory = Path.Combine(Path.GetTempPath(), "TroLyUninstall-" + Guid.NewGuid().ToString("N"));
        Directory.CreateDirectory(workerDirectory);
        string workerExe = Path.Combine(workerDirectory, "Uninstall.exe");
        File.Copy(Assembly.GetExecutingAssembly().Location, workerExe);
        string workerArgs = "--worker " + Process.GetCurrentProcess().Id + (test ? " --integration-uninstall" : "");
        Process.Start(new ProcessStartInfo(workerExe, workerArgs) { UseShellExecute = false, CreateNoWindow = true, WindowStyle = ProcessWindowStyle.Hidden });
        return 0;
    }

    private static void Require(bool condition, string description)
    {
        if (!condition) throw new InvalidDataException("Integration check: " + description);
    }

    private static int IntegrationCheck()
    {
        if (!IsIntegrationManifest()) throw new InvalidOperationException("Integration check requires an isolated test manifest.");
        string checkRoot = CheckRoot();
        Directory.CreateDirectory(checkRoot);
        string root = Path.Combine(checkRoot, manifest.InstallFolder);
        Directory.CreateDirectory(root);
        string userFile = Path.Combine(root, "user-note.txt");
        File.WriteAllText(userFile, "keep personal data");
        string outside = Path.Combine(checkRoot, "personal-data.txt");
        File.WriteAllText(outside, "keep outside app");
        terms = ReadTextResource(TermsResource);
        string currentVersion = manifest.Version;
        string legacy = Path.Combine(root, "Uninstall-" + manifest.InstallFolder + ".exe");
        File.WriteAllText(legacy, "legacy executable");
        bool protectedLegacy = manifest.AppId.StartsWith("teacher", StringComparison.Ordinal);
        if (protectedLegacy) File.SetAttributes(legacy, FileAttributes.ReadOnly);
        using (var heldLegacy = new FileStream(legacy, FileMode.Open, FileAccess.Read, FileShare.Read))
        {
            manifest.Version = "previous-test";
            using (var form = new SetupForm()) Require(Directory.Exists(form.InstallForCheck(root)), "fresh install");
            string previousUninstaller;
            using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath()))
                previousUninstaller = ((string)key.GetValue("UninstallString")).Split('"')[1];
            using (var heldUninstaller = new FileStream(previousUninstaller, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                manifest.Version = currentVersion;
                using (var form = new SetupForm()) Require(Directory.Exists(form.InstallForCheck(root)), "upgrade with locked old uninstaller");
                using (var form = new SetupForm()) Require(Directory.Exists(form.InstallForCheck(root)), "same-version repair");
            }
        }
        Require(File.ReadAllText(legacy) == "legacy executable", "old uninstaller unchanged");
        Require(Directory.Exists(Path.Combine(root, "versions", "previous-test")), "previous version preserved on upgrade");
        Require(File.Exists(StartMenuLink()) && File.Exists(UninstallMenuLink()) && File.Exists(DesktopLink()), "application, uninstall and desktop shortcuts");
        string registeredUninstaller;
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath()))
        {
            Require((string)key.GetValue("DisplayVersion") == currentVersion, "registered current version");
            registeredUninstaller = ((string)key.GetValue("UninstallString")).Split('"')[1];
        }
        Require(new FileInfo(registeredUninstaller).Length < 1024 * 1024, "standalone small uninstaller");
        using (Process process = Process.Start(new ProcessStartInfo(registeredUninstaller, "--integration-uninstall") { UseShellExecute = false, CreateNoWindow = true }))
        {
            Require(process.WaitForExit(30000) && process.ExitCode == 0, "uninstaller launcher");
        }
        string result = Path.Combine(checkRoot, "uninstall-result.txt");
        var timer = Stopwatch.StartNew();
        while (!File.Exists(result) && timer.ElapsedMilliseconds < 30000)
        {
            if (File.Exists(Path.Combine(checkRoot, "failure.txt"))) throw new IOException(File.ReadAllText(Path.Combine(checkRoot, "failure.txt")));
            System.Threading.Thread.Sleep(100);
        }
        Require(File.Exists(result), "uninstall completion");
        if (protectedLegacy)
            Require(File.Exists(legacy) && File.ReadAllText(result).Trim() != "PASS", "blocked legacy file reported without blocking uninstall");
        Require(!Directory.Exists(Path.Combine(root, "versions")), "application files removed");
        Require(!Directory.Exists(Path.Combine(root, ".maintenance")), "installed uninstaller removed");
        Require(!File.Exists(StartMenuLink()) && !File.Exists(UninstallMenuLink()) && !File.Exists(DesktopLink()), "shortcuts removed");
        using (RegistryKey key = Registry.CurrentUser.OpenSubKey(RegistryPath())) Require(key == null, "uninstall registry removed");
        Require(File.ReadAllText(userFile) == "keep personal data" && File.ReadAllText(outside) == "keep outside app", "personal files preserved");
        Console.WriteLine("PASS " + manifest.AppId + ": fresh install, locked-file upgrade, same-version repair, real uninstall, personal data preserved");
        Console.WriteLine("Test evidence: " + checkRoot);
        return 0;
    }
}
