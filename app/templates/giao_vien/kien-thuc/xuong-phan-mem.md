# Kiến thức Xưởng phần mềm - ứng dụng web chạy offline cho lớp học

Dùng cùng quy trình `/xuong-phan-mem`. Chỉ đọc mục cần.

## 1. Kiến trúc chuẩn một dự án

```
10_PHAN_MEM/
├── .tro-ly/_MUC_LUC.md              mỗi dự án một dòng
├── _dong-goi/<Tên dự án> <ngày>.zip  bản gửi học sinh
└── <ten-du-an>/                      tên không dấu, nối gạch ngang
    ├── index.html   khung trang; nạp style.css, rồi <script src="du-lieu.js">, <script src="app.js">
    ├── style.css    giao diện
    ├── du-lieu.js   NỘI DUNG: window.DU_LIEU = { ... }  (giáo viên sửa được, không đụng mã)
    ├── app.js       mã chạy, bọc trong (function(){ "use strict"; ... })();
    ├── anh/         (khi cần) ảnh .png/.jpg/.svg dùng bằng <img src="anh/ten.png">
    └── .tro-ly/     README.md, ban-cu/<ngày giờ>/, ảnh chụp kiểm tra
```

- Thứ tự nạp: `du-lieu.js` **trước** `app.js`; cả hai đặt cuối `<body>` (khỏi cần chờ DOMContentLoaded).
- `app.js` đọc `var D = window.DU_LIEU || {};` và chịu được dữ liệu thiếu (mảng rỗng, khóa không có) - hiện dòng báo "Chưa có ... trong du-lieu.js" thay vì trắng trang.
- Dữ liệu người dùng nhập (tên đội, danh sách) chèn bằng `textContent`, không dùng `innerHTML` với chuỗi từ dữ liệu.
- Tên biến, hàm tiếng Việt không dấu (`cauHoi`, `batDau`, `veBangDiem`) và chú thích tiếng Việt có dấu - giáo viên đọc hiểu được.
- Phong cách chung (giống các mẫu `{{HE_THONG}}\mau\phan-mem\`): nền `#14213D`, lớp nền `#1B2B4F` / `#243A66`, viền `#3A5688`, chữ trắng, nhấn vàng `#F2C94C`, đúng `#2F7A5A` (sáng `#4FC08D`), sai `#E85D4A`; phông `"Segoe UI", system-ui, sans-serif`; `[hidden]{display:none!important}`.

## 2. Đoạn mã hay dùng

**Toàn màn hình** (phải gọi từ cú bấm chuột/phím của người dùng):
```js
function batTatToanManHinh() {
  var d = document, el = d.documentElement, p;
  try {
    if (!d.fullscreenElement && !d.webkitFullscreenElement) p = (el.requestFullscreen || el.webkitRequestFullscreen).call(el);
    else p = (d.exitFullscreen || d.webkitExitFullscreen).call(d);
    if (p && p.catch) p.catch(function () {});
  } catch (e) {}
}
```

**Âm thanh bằng Web Audio** (không cần tệp mp3; trình duyệt chỉ cho phát sau cú bấm đầu tiên):
```js
var amCtx = null, tatTieng = false;
function beep(tanSo, thoiGian, kieu, amLuong, treo) {
  if (tatTieng) return;
  try {
    if (!amCtx) { var AC = window.AudioContext || window.webkitAudioContext; if (!AC) return; amCtx = new AC(); }
    if (amCtx.state === "suspended") amCtx.resume();
    var t0 = amCtx.currentTime + (treo || 0), o = amCtx.createOscillator(), g = amCtx.createGain();
    o.type = kieu || "sine"; o.frequency.value = tanSo;
    g.gain.setValueAtTime(0.0001, t0);
    g.gain.exponentialRampToValueAtTime(amLuong || 0.3, t0 + 0.02);
    g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
    o.connect(g); g.connect(amCtx.destination); o.start(t0); o.stop(t0 + thoiGian + 0.05);
  } catch (e) {}
}
// đúng: beep(660,.15); beep(880,.15,"sine",.35,.12); beep(1320,.35,"sine",.35,.24)
// sai: beep(220,.35,"sawtooth",.2); beep(170,.45,"sawtooth",.2,.18)
// tích tắc: beep(880,.08,"square",.12) · chuông: beep(880,1.4,"sine",.45) + beep(1320,1,"sine",.18)
```

**Xáo trộn Fisher-Yates** (đừng dùng `sort(() => Math.random() - .5)` - lệch):
```js
function xaoTron(mang) {
  for (var i = mang.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var t = mang[i]; mang[i] = mang[j]; mang[j] = t;
  }
  return mang;
}
```

**localStorage an toàn** (có thể bị chặn ở file://, chế độ ẩn danh, WebView):
```js
var KHOA_LUU = "ten-du-an:" + (D.tieuDe || "");
function docTam(macDinh) { try { var s = localStorage.getItem(KHOA_LUU); return s ? JSON.parse(s) : macDinh; } catch (e) { return macDinh; } }
function luuTam(v) { try { localStorage.setItem(KHOA_LUU, JSON.stringify(v)); } catch (e) {} }
```
Mọi trang file:// trên cùng máy có thể dùng chung kho - luôn đặt khóa có tiền tố tên dự án. Dữ liệu chỉ nằm trên máy, trình duyệt đó; xóa lịch sử duyệt web là mất.

**Phím tắt** (bỏ qua khi đang gõ chữ; chặn Space cuộn trang):
```js
document.addEventListener("keydown", function (e) {
  if (e.ctrlKey || e.altKey || e.metaKey) return;
  if (/^(INPUT|SELECT|TEXTAREA)$/.test(e.target.tagName)) return;
  var k = e.key.length === 1 ? e.key.toLowerCase() : e.key;
  if (k === " ") { e.preventDefault(); /* hành động chính */ }
  else if (/^[1-4]$/.test(k)) { /* chọn phương án +k - 1 */ }
  else if (k === "f") batTatToanManHinh();
});
// Sau khi bấm chuột vào nút, bỏ tiêu điểm để Space/Enter không bấm lại nút đó:
document.addEventListener("click", function (e) { var b = e.target.closest && e.target.closest("button"); if (b) b.blur(); });
```

**Đếm ngược không lệch**: lưu `ketThucLuc = Date.now() + conLai` rồi `setInterval(..., 200)` tính `conLai = ketThucLuc - Date.now()`; hiển thị `Math.ceil(conLai/1000)`.

**Canvas nét, đúng cỡ**: `canvas.width = cssRong * devicePixelRatio; ctx.setTransform(dpr,0,0,dpr,0,0)`; vẽ lại khi `resize`. Hoạt hình dùng `requestAnimationFrame`, làm chậm dần `e = 1 - Math.pow(1 - p, 4)`.

**Chữ tiếng Việt**: so sánh đáp án gõ tay: `s.normalize("NFC").toUpperCase().replace(/[^\p{L}\p{N}]/gu, "")`; bỏ dấu: `normalize("NFD").replace(/\p{M}/gu,"").replace(/Đ/g,"D")`. Tách chữ cái bằng `Array.from(s)` (sau NFC).

**Chữ to theo khung**: `font-size: clamp(28px, 4vw, 52px)`; trong khối vuông co giãn dùng `container-type: size` + `font-size: 25cqmin`.

**Ảnh**: SVG viết thẳng trong HTML, hoặc `<img src="anh/hinh.png">` (đường dẫn tương đối), hoặc `data:image/svg+xml;utf8,...`. Không dùng ảnh trên mạng.

## 3. Lỗi thường gặp khi mở bằng file:// và cách tránh

| Lỗi | Biểu hiện | Cách tránh |
|---|---|---|
| `fetch("du-lieu.json")`, `XMLHttpRequest` tệp cục bộ | Bị chặn CORS, trắng dữ liệu | Dữ liệu viết thành `du-lieu.js` với `window.DU_LIEU = {...}` |
| `<script type="module">`, `import ... from` | Bị chặn, không chạy gì | Chỉ `<script src="...">` thường, biến chung qua `window` |
| CDN (jQuery, Bootstrap, Chart.js...), Google Fonts | Lớp học không mạng → vỡ giao diện, lỗi `$ is not defined` | Không dùng; viết JS thuần; phông hệ thống |
| Đường dẫn tuyệt đối `/style.css`, `C:\...` | Không nạp được khi chép sang máy khác | Luôn tương đối: `style.css`, `anh/a.png` |
| Tên tệp có dấu, dấu cách, hoa/thường lẫn lộn | Mở trên máy khác, trong zip, trên web lỗi | Tên tệp không dấu, chữ thường, gạch ngang |
| Thiếu `<meta charset="utf-8">` hoặc lưu tệp không phải UTF-8 | Chữ tiếng Việt vỡ | Luôn có meta charset, lưu UTF-8 |
| localStorage bị chặn/throw | Cả ứng dụng dừng | Luôn `try/catch` (mục 2) |
| Âm thanh không kêu | AudioContext "suspended" trước tương tác | Tạo/`resume()` trong cú bấm đầu tiên |
| `requestFullscreen` báo lỗi | Gọi ngoài sự kiện người dùng | Chỉ gọi trong click/keydown; bắt `.catch` |
| Lỗi JS giữa chừng làm trắng trang | Một lỗi cú pháp dừng cả tệp | `node --check app.js`, `node --check du-lieu.js`; dữ liệu thiếu dấu phẩy là lỗi hay gặp nhất khi giáo viên tự sửa |
| Phần tử có `display:flex` không ẩn được bằng `hidden` | Hai màn chồng nhau | CSS `[hidden]{display:none!important}` |
| Space cuộn trang / bấm lại nút đang được chọn | Hành động chạy hai lần | `e.preventDefault()` và `blur()` nút sau click |
| `alert()`, `prompt()` | Khó nhìn trên máy chiếu, WebView có thể chặn | Dùng lớp phủ tự vẽ |
| Tràn màn hình 1024×768 | Nút cuối bị khuất | Bố cục flex cột, vùng giữa `flex:1; min-height:0`; chụp kiểm tra ở 1024×768 |

## 4. Kiểm tra trước khi báo xong

1. `node --check <tệp>.js` cho từng tệp .js (có node).
2. Chụp ảnh bằng Edge headless ở 1366×768 và 1024×768, **mở ảnh ra xem**: chữ tiếng Việt, tràn, chồng lấn, nút khuất.
   `& "C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe" --headless --disable-gpu --user-data-dir="$env:TEMP\xuong-edge" --screenshot="<dự án>\.tro-ly\chup-1366.png" --window-size=1366,768 "file:///J:/.../10_PHAN_MEM/<dự án>/index.html"`
   - Đường dẫn có dấu tiếng Việt, dấu cách vẫn chạy; đổi `\` thành `/`.
   - Thêm `--virtual-time-budget=3000` để hẹn giờ kịp chạy trước khi chụp.
   - Muốn chụp màn thứ hai (sau khi bấm Bắt đầu): chép dự án ra `%TEMP%`, thêm một `<script>` bấm hộ (`document.getElementById("nutBatDau").click()`) rồi chụp bản chép - không sửa bản thật. `requestAnimationFrame` có thể không chạy trong chế độ chụp; thay tạm bằng `setTimeout` trong bản chép.
3. Soát logic bằng mắt: đáp án đúng chỉ số (đếm từ 0), hết câu → màn kết thúc, chơi lại xóa điểm, phím tắt không xung đột.

## 5. Dạy giáo viên hiểu mã từng bước (khi thầy/cô hỏi)

Mỗi lần một ý, ví dụ ngay trên dự án của thầy/cô, dùng so sánh đời thường, sau mỗi bước đề nghị một thay đổi nhỏ để tự làm rồi bấm Tải lại xem kết quả.

1. **Ba lớp của trang**: `index.html` là "bộ khung, đồ đạc", `style.css` là "sơn, trang trí", `app.js` là "điện, công tắc" - làm cho nút bấm được. `du-lieu.js` là "tờ đề" thay được mà không đụng máy.
2. **Sửa dữ liệu**: mở `du-lieu.js` bằng Notepad; mỗi câu là một cặp `{ }`, giữa các câu có dấu phẩy, chữ trong ngoặc kép. Thử đổi một câu hỏi. Lỗi hay gặp: thiếu dấu phẩy, thiếu ngoặc kép.
3. **Đổi màu, cỡ chữ**: trong `style.css` tìm `--vang: #F2C94C`, đổi mã màu; tìm `font-size` của `.cau-hoi`. Giải thích `px`, mã màu `#RRGGBB`.
4. **Thẻ HTML**: `<button id="nutBatDau">Bắt đầu</button>` - `id` là "tên riêng" để JS tìm đến.
5. **Biến và hàm**: `var diem = 0;` là "cái hộp nhớ số"; `function congDiem() { ... }` là "một việc có tên", gọi `congDiem()` là làm việc đó.
6. **Sự kiện**: `nut.addEventListener("click", batDau)` = "khi bấm nút thì làm việc batDau".
7. **Điều kiện, vòng lặp**: `if (chon === dapAn) { ... } else { ... }`; `for` / `forEach` để làm lần lượt với từng câu, từng đội.
8. **Tự tìm lỗi**: bấm `F12` trong Edge/Chrome → tab Console, dòng đỏ cho biết tệp và số dòng lỗi.
9. Khi thầy/cô muốn tự viết thêm: gợi ý bắt đầu từ mẫu `trong`, thêm một nút và một hàm; trợ lý xem lại mã và giải thích chỗ sai thay vì viết lại hết.
