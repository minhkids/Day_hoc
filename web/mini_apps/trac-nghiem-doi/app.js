/* Trắc nghiệm thi đua đội - phần mã chạy trò chơi đa lớp & tự nhập câu hỏi. */
(function () {
  "use strict";

  var NGAN_HANG = window.NGAN_HANG_TRAC_NGHIEM || {};
  var D = window.DU_LIEU || {};
  var CHU = ["A", "B", "C", "D", "E", "F"];

  function $(id) { return document.getElementById(id); }
  function gioiHan(x, a, b) { return Math.min(b, Math.max(a, x)); }

  /* ---------- Lưu tạm cấu hình & đề tự tạo ---------- */
  var KHOA_LUU_CAU_HINH = "tn-doi:cau-hinh";
  var KHOA_LUU_DE_RIENG = "tn-doi:de-tu-tao";
  var KHOA_LUU_LOP = "tn-doi:lop-da-chon";

  function docStorage(khoa, macDinh) {
    try { var s = localStorage.getItem(khoa); return s ? JSON.parse(s) : macDinh; } catch (e) { return macDinh; }
  }
  function luuStorage(khoa, giaTri) {
    try { localStorage.setItem(khoa, JSON.stringify(giaTri)); } catch (e) { /* bỏ qua */ }
  }

  /* ---------- Âm thanh bằng Web Audio ---------- */
  var amCtx = null, tatTieng = false;
  function beep(tanSo, thoiGian, kieu, amLuong, treo) {
    if (tatTieng) return;
    try {
      if (!amCtx) {
        var AC = window.AudioContext || window.webkitAudioContext;
        if (!AC) return;
        amCtx = new AC();
      }
      if (amCtx.state === "suspended") amCtx.resume();
      var t0 = amCtx.currentTime + (treo || 0);
      var osc = amCtx.createOscillator(), g = amCtx.createGain();
      osc.type = kieu || "sine";
      osc.frequency.value = tanSo;
      g.gain.setValueAtTime(0.0001, t0);
      g.gain.exponentialRampToValueAtTime(amLuong || 0.3, t0 + 0.02);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
      osc.connect(g); g.connect(amCtx.destination);
      osc.start(t0); osc.stop(t0 + thoiGian + 0.05);
    } catch (e) { /* máy không hỗ trợ âm thanh */ }
  }
  var AM = {
    tich: function () { beep(880, 0.08, "square", 0.12); },
    dung: function () { beep(660, 0.15, "sine", 0.35); beep(880, 0.15, "sine", 0.35, 0.12); beep(1320, 0.35, "sine", 0.35, 0.24); },
    sai: function () { beep(220, 0.35, "sawtooth", 0.2); beep(170, 0.45, "sawtooth", 0.2, 0.18); },
    hetGio: function () { beep(440, 0.7, "triangle", 0.4); beep(330, 0.9, "triangle", 0.35, 0.35); },
    cong: function () { beep(988, 0.12, "sine", 0.3); },
    chon: function () { beep(587, 0.1, "sine", 0.2); },
    chienThang: function () { [523, 659, 784, 1047].forEach(function (f, i) { beep(f, 0.35, "triangle", 0.35, i * 0.16); }); }
  };
  function doiAm() {
    tatTieng = !tatTieng;
    $("nutAm").textContent = tatTieng ? "Âm thanh: Tắt" : "Âm thanh: Bật";
  }

  /* ---------- Toàn màn hình ---------- */
  function batTatToanManHinh() {
    var d = document, el = d.documentElement, p;
    try {
      if (!d.fullscreenElement && !d.webkitFullscreenElement) {
        p = (el.requestFullscreen || el.webkitRequestFullscreen).call(el);
      } else {
        p = (d.exitFullscreen || d.webkitExitFullscreen).call(d);
      }
      if (p && p.catch) p.catch(function () {});
    } catch (e) { /* trình duyệt không cho phép */ }
  }

  /* ---------- Xáo trộn Fisher-Yates ---------- */
  function xaoTron(mang) {
    for (var i = mang.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = mang[i]; mang[i] = mang[j]; mang[j] = t;
    }
    return mang;
  }

  /* ---------- Quản lý dữ liệu theo Lớp & Đề tự tạo ---------- */
  var deTuTao = docStorage(KHOA_LUU_DE_RIENG, null);
  var maLopHienTai = docStorage(KHOA_LUU_LOP, "lop-8");

  function layDuLieuLop(maLop) {
    if (maLop === "tu-nhap") {
      if (deTuTao && Array.isArray(deTuTao.cauHoi) && deTuTao.cauHoi.length > 0) {
        return deTuTao;
      }
      return {
        tieuDe: "Đề Tự Tạo Của Tôi",
        monLop: "Tự soạn",
        thoiGianMoiCau: 20,
        diemMoiCau: 10,
        cauHoi: []
      };
    }
    if (NGAN_HANG[maLop]) {
      return NGAN_HANG[maLop];
    }
    return NGAN_HANG["lop-8"] || D;
  }

  var duLieuHienTai = layDuLieuLop(maLopHienTai);
  var DS_CAU = duLieuHienTai.cauHoi || [];

  /* ---------- Trạng thái trò chơi ---------- */
  var cauHinhLuu = docStorage(KHOA_LUU_CAU_HINH, {});
  var S = {
    soDoi: gioiHan(parseInt(cauHinhLuu.soDoi || 4, 10) || 4, 2, 6),
    giay: gioiHan(parseInt(cauHinhLuu.giay || duLieuHienTai.thoiGianMoiCau || 20, 10) || 20, 5, 300),
    diem: gioiHan(parseInt(cauHinhLuu.diem || duLieuHienTai.diemMoiCau || 10, 10) || 10, 1, 100),
    tenDoi: (cauHinhLuu.tenDoi || ["Đội 1", "Đội 2", "Đội 3", "Đội 4"]).slice(),
    xaoTron: !!cauHinhLuu.xaoTron,
    tuDongDapAn: cauHinhLuu.tuDongDapAn !== false,
    thuTu: [], cau: 0, chon: -1,
    doiTraLoi: -1, // Đội giành quyền trả lời câu hiện tại
    daMoDapAn: false,
    conLai: 0, tongGio: 1, hen: null, dangChay: false,
    trangThai: "bat-dau", diemDoi: []
  };

  function capNhatTieuDeLop() {
    $("tieuDe").textContent = "⚔️ " + (duLieuHienTai.tieuDe || "Đấu Trường Trắc Nghiệm");
    $("monLop").textContent = duLieuHienTai.monLop || "";
    $("moTaLopHienTai").textContent = (duLieuHienTai.monLop ? "📚 " + duLieuHienTai.monLop + " • " : "") + (DS_CAU.length) + " câu hỏi sẵn sàng";
  }

  function doiGoiLop(maLop, batBuocNap) {
    maLopHienTai = maLop;
    luuStorage(KHOA_LUU_LOP, maLop);
    $("chonLop").value = maLop;

    duLieuHienTai = layDuLieuLop(maLop);
    DS_CAU = duLieuHienTai.cauHoi || [];

    if (maLop === "tu-nhap" && DS_CAU.length === 0) {
      moModalNhap(true);
    }

    S.giay = duLieuHienTai.thoiGianMoiCau || 20;
    S.diem = duLieuHienTai.diemMoiCau || 10;
    $("thoiGian").value = S.giay;
    $("diemMoiCau").value = S.diem;

    capNhatTieuDeLop();
    veCauHinh();
    hienMan("manBatDau");
  }

  function hienMan(id) {
    ["manBatDau", "manHoi", "manKetThuc"].forEach(function (m) { $(m).hidden = (m !== id); });
  }

  /* ---------- Màn chuẩn bị ---------- */
  function veCauHinh() {
    var sel = $("soDoi");
    sel.innerHTML = "";
    for (var i = 2; i <= 6; i++) {
      var opt = document.createElement("option");
      opt.value = i; opt.textContent = i + " đội";
      if (i === S.soDoi) opt.selected = true;
      sel.appendChild(opt);
    }

    $("thoiGian").value = S.giay;
    $("diemMoiCau").value = S.diem;
    $("xaoTron").checked = S.xaoTron;
    $("tuDongDapAn").checked = S.tuDongDapAn;

    veOdoi();
    $("soCau").textContent = "Tổng số: " + DS_CAU.length + " câu hỏi trong ngân hàng này.";
    $("nutBatDau").disabled = (DS_CAU.length === 0);
    if (DS_CAU.length === 0) {
      $("soCau").textContent = "⚠️ Chưa có câu hỏi nào. Hãy bấm 'Tự nhập câu hỏi' ở trên để thêm câu hỏi!";
    }
  }

  function veOdoi() {
    var c = $("tenDoi");
    c.innerHTML = "";
    while (S.tenDoi.length < S.soDoi) S.tenDoi.push("Đội " + (S.tenDoi.length + 1));
    for (var i = 0; i < S.soDoi; i++) {
      (function (idx) {
        var inp = document.createElement("input");
        inp.type = "text"; inp.maxLength = 24;
        inp.value = S.tenDoi[idx] || ("Đội " + (idx + 1));
        inp.className = "mau-" + (idx % 6);
        inp.addEventListener("input", function () {
          S.tenDoi[idx] = inp.value;
          luuCauHinh();
        });
        c.appendChild(inp);
      })(i);
    }
  }

  function luuCauHinh() {
    luuStorage(KHOA_LUU_CAU_HINH, {
      soDoi: S.soDoi,
      giay: S.giay,
      diem: S.diem,
      tenDoi: S.tenDoi.slice(0, S.soDoi),
      xaoTron: S.xaoTron,
      tuDongDapAn: S.tuDongDapAn
    });
  }

  /* ---------- Bắt đầu trận đấu ---------- */
  function batDauChoi() {
    if (!DS_CAU.length) {
      alert("Chưa có câu hỏi nào. Vui lòng chọn lớp khác hoặc bấm 'Tự nhập câu hỏi'!");
      return;
    }
    S.soDoi = parseInt($("soDoi").value, 10) || 4;
    S.giay = parseInt($("thoiGian").value, 10) || 20;
    S.diem = parseInt($("diemMoiCau").value, 10) || 10;
    S.xaoTron = $("xaoTron").checked;
    S.tuDongDapAn = $("tuDongDapAn").checked;
    luuCauHinh();

    S.diemDoi = [];
    for (var i = 0; i < S.soDoi; i++) S.diemDoi.push(0);

    S.thuTu = [];
    for (var j = 0; j < DS_CAU.length; j++) S.thuTu.push(j);
    if (S.xaoTron) xaoTron(S.thuTu);

    S.cau = 0;
    hienMan("manHoi");
    veBangDiem();
    veNutChonDoi();
    hienThiCau(0);
  }

  /* ---------- Màn câu hỏi & tương tác trả lời ---------- */
  function veNutChonDoi() {
    var c = $("danhSachNutDoi");
    c.innerHTML = "";
    for (var i = 0; i < S.soDoi; i++) {
      (function (idx) {
        var b = document.createElement("button");
        b.type = "button";
        b.className = "nut-doi-tl" + (S.doiTraLoi === idx ? " dang-chon" : "");
        b.textContent = (idx + 1) + ". " + (S.tenDoi[idx] || ("Đội " + (idx + 1)));
        b.addEventListener("click", function () {
          chonDoiTraLoi(idx);
        });
        c.appendChild(b);
      })(i);
    }
  }

  function chonDoiTraLoi(idx) {
    if (S.doiTraLoi === idx) {
      S.doiTraLoi = -1; // Bỏ chọn
    } else {
      S.doiTraLoi = idx;
      AM.chon();
    }
    veNutChonDoi();
  }

  function hienThiCau(chiso) {
    dungDemGio();
    S.cau = chiso;
    S.chon = -1;
    S.doiTraLoi = -1;
    S.daMoDapAn = false;
    veNutChonDoi();

    var cauGoc = DS_CAU[S.thuTu[chiso]];
    $("soThuTu").textContent = "Câu " + (chiso + 1) + "/" + S.thuTu.length;

    var elHoi = $("cauHoi");
    elHoi.textContent = cauGoc.hoi;
    elHoi.classList.toggle("dai", cauGoc.hoi.length > 70);

    var elPA = $("phuongAn");
    elPA.innerHTML = "";
    (cauGoc.phuongAn || []).forEach(function (pa, i) {
      var btn = document.createElement("button");
      btn.type = "button";
      btn.className = "pa";
      btn.innerHTML = '<span class="chu-cai">' + CHU[i] + '</span><span class="chu">' + pa + '</span>';
      btn.addEventListener("click", function () {
        traLoiPhuongAn(i);
      });
      elPA.appendChild(btn);
    });

    $("giaiThich").textContent = "";
    $("nutHienDapAn").disabled = false;
    $("nutTiep").textContent = (chiso === S.thuTu.length - 1) ? "Kết thúc 🏁" : "Câu tiếp ➜";

    var giayCau = cauGoc.thoiGian || S.giay;
    batDauDemGio(giayCau);
  }

  /* Học sinh / Người chơi bấm chọn phương án */
  function traLoiPhuongAn(idx) {
    if (S.daMoDapAn) return;

    S.chon = idx;
    AM.chon();

    var danhSachPA = $("phuongAn").children;
    for (var i = 0; i < danhSachPA.length; i++) {
      danhSachPA[i].classList.toggle("chon", i === idx);
    }

    // Nếu bật tự động chấm khi bấm thì mở đáp án ngay
    if (S.tuDongDapAn) {
      moDapAn();
    }
  }

  /* Bấm mở đáp án */
  function moDapAn() {
    if (S.daMoDapAn) return;
    S.daMoDapAn = true;
    dungDemGio();

    var cauGoc = DS_CAU[S.thuTu[S.cau]];
    var dungIdx = cauGoc.dapAn;

    var danhSachPA = $("phuongAn").children;
    for (var i = 0; i < danhSachPA.length; i++) {
      danhSachPA[i].classList.remove("chon");
      if (i === dungIdx) {
        danhSachPA[i].classList.add("dung");
      } else if (i === S.chon) {
        danhSachPA[i].classList.add("sai");
      } else {
        danhSachPA[i].classList.add("mo");
      }
    }

    var daChonDung = (S.chon === dungIdx);
    if (S.chon !== -1) {
      if (daChonDung) {
        AM.dung();
        // Nếu đã chỉ định đội giành quyền trả lời -> Tự động cộng điểm cho đội đó!
        if (S.doiTraLoi >= 0 && S.doiTraLoi < S.soDoi) {
          congDiem(S.doiTraLoi, S.diem);
        }
      } else {
        AM.sai();
      }
    } else {
      AM.hetGio();
    }

    if (cauGoc.giaiThich) {
      $("giaiThich").textContent = "💡 " + cauGoc.giaiThich;
    }
    $("nutHienDapAn").disabled = true;
  }

  function tiepTheo() {
    if (!S.daMoDapAn) {
      moDapAn();
      return;
    }
    if (S.cau + 1 < S.thuTu.length) {
      hienThiCau(S.cau + 1);
    } else {
      ketThuc();
    }
  }

  /* ---------- Đếm giờ ---------- */
  function batDauDemGio(giay) {
    S.conLai = giay;
    S.tongGio = giay;
    S.dangChay = true;
    capNhatDongHo();
    clearInterval(S.hen);
    S.hen = setInterval(function () {
      if (!S.dangChay) return;
      S.conLai--;
      capNhatDongHo();
      if (S.conLai <= 5 && S.conLai > 0) AM.tich();
      if (S.conLai <= 0) {
        dungDemGio();
        moDapAn();
      }
    }, 1000);
  }

  function dungDemGio() {
    clearInterval(S.hen);
    S.dangChay = false;
  }

  function tamDungHoacChay() {
    if (S.daMoDapAn) return;
    S.dangChay = !S.dangChay;
    $("nutDungGio").textContent = S.dangChay ? "⏸ Tạm dừng" : "▶ Tiếp tục";
  }

  function capNhatDongHo() {
    var tg = $("thanhGio"), so = $("soGiay");
    var pt = (S.conLai / S.tongGio) * 100;
    tg.style.width = pt + "%";
    so.textContent = S.conLai;

    var lopTren = $("manHoi").querySelector(".hang-tren");
    lopTren.classList.toggle("canh-bao", S.conLai <= 5 && S.conLai > 0);
    lopTren.classList.toggle("het-gio", S.conLai <= 0);
  }

  /* ---------- Điểm số & Bảng xếp hạng ---------- */
  function congDiem(doiIdx, delta) {
    S.diemDoi[doiIdx] = Math.max(0, S.diemDoi[doiIdx] + delta);
    AM.cong();
    veBangDiem(doiIdx);
  }

  function veBangDiem(nhayDoi) {
    var c = $("bangDiem");
    c.innerHTML = "";
    for (var i = 0; i < S.soDoi; i++) {
      (function (idx) {
        var o = document.createElement("div");
        o.className = "o-doi mau-" + (idx % 6) + (idx === nhayDoi ? " nhay" : "");
        o.innerHTML =
          '<div class="ten">' + (S.tenDoi[idx] || ("Đội " + (idx + 1))) + '</div>' +
          '<div class="diem">' + S.diemDoi[idx] + '</div>' +
          '<div class="nut-diem">' +
            '<button class="nut" type="button" title="Cộng điểm">+' + S.diem + '</button>' +
            '<button class="nut" type="button" title="Trừ điểm">−' + S.diem + '</button>' +
          '</div>';

        var bts = o.querySelectorAll("button");
        bts[0].addEventListener("click", function () { congDiem(idx, S.diem); });
        bts[1].addEventListener("click", function () { congDiem(idx, -S.diem); });
        c.appendChild(o);
      })(i);
    }
  }

  function ketThuc() {
    dungDemGio();
    hienMan("manKetThuc");
    AM.chienThang();

    var ds = [];
    for (var i = 0; i < S.soDoi; i++) {
      ds.push({ ten: S.tenDoi[i] || ("Đội " + (i + 1)), diem: S.diemDoi[i], idx: i });
    }
    ds.sort(function (a, b) { return b.diem - a.diem; });

    var ol = $("xepHang");
    ol.innerHTML = "";
    ds.forEach(function (d, rank) {
      var li = document.createElement("li");
      if (rank === 0) li.classList.add("nhat");
      li.classList.add("mau-" + (d.idx % 6));
      li.innerHTML =
        '<span class="hang">' + (rank === 0 ? "🥇 Quán quân" : (rank === 1 ? "🥈 Hạng nhì" : (rank === 2 ? "🥉 Hạng ba" : "Hạng " + (rank + 1)))) + '</span>' +
        '<span class="ten">' + d.ten + '</span>' +
        '<span class="diem">' + d.diem + ' đ</span>';
      ol.appendChild(li);
    });
  }

  /* ---------- Tự nhập câu hỏi (Parser & Quản lý) ---------- */
  function moModalNhap(sangTabDan) {
    $("modalNhapCauHoi").hidden = false;
    if (sangTabDan) {
      chuyenTab("dan");
    } else {
      veDanhSachCauTrongModal();
      chuyenTab("danhsach");
    }
  }
  function dongModalNhap() {
    $("modalNhapCauHoi").hidden = true;
  }

  function chuyenTab(tab) {
    var bDan = $("tabDanVanBan"), bDS = $("tabDanhSachCau");
    var cDan = $("noiDungDanVanBan"), cDS = $("noiDungDanhSachCau");
    if (tab === "dan") {
      bDan.classList.add("kich-hoat"); bDS.classList.remove("kich-hoat");
      cDan.hidden = false; cDS.hidden = true;
    } else {
      bDS.classList.add("kich-hoat"); bDan.classList.remove("kich-hoat");
      cDS.hidden = false; cDan.hidden = true;
      veDanhSachCauTrongModal();
    }
  }

  /* Bộ phân tích cú pháp đề trắc nghiệm thông minh */
  function phanTichVanBanDe(vanBan) {
    if (!vanBan || !vanBan.trim()) return [];
    var dong = vanBan.split(/\r?\n/);
    var ketQua = [];
    var cauHienTai = null;

    for (var i = 0; i < dong.length; i++) {
      var d = dong[i].trim();
      if (!d) continue;

      // Nhận diện câu hỏi: Câu 1: / Câu 1. / 1: / 1. / Q1:
      var khopHoi = d.match(/^(?:Câu\s*\d+[\s.:\)-]|\d+[\s.:\)-]|Question\s*\d+[\s.:\)-])\s*(.+)$/i);
      if (khopHoi) {
        if (cauHienTai && cauHienTai.phuongAn.length >= 2) {
          ketQua.push(chuanHoaCau(cauHienTai));
        }
        cauHienTai = { hoi: khopHoi[1], phuongAn: [], dapAn: 0, giaiThich: "" };
        continue;
      }

      // Nhận diện dạng bảng phân cách bởi dấu gạch đứng (|): Câu hỏi | A | B | C | D | Đáp án | Giải thích
      if (d.indexOf("|") > 0) {
        var parts = d.split("|").map(function (s) { return s.trim(); });
        if (parts.length >= 5) {
          var daIdx = 0;
          var daStr = (parts[5] || "A").toUpperCase();
          if (daStr === "B" || daStr === "1") daIdx = 1;
          else if (daStr === "C" || daStr === "2") daIdx = 2;
          else if (daStr === "D" || daStr === "3") daIdx = 3;
          ketQua.push({
            hoi: parts[0],
            phuongAn: [parts[1], parts[2], parts[3], parts[4]],
            dapAn: daIdx,
            giaiThich: parts[6] || ""
          });
          continue;
        }
      }

      // Nhận diện phương án A, B, C, D (hoặc *A, *B đánh dấu đúng)
      var khopPA = d.match(/^([*]?)\s*([A-Fa-f])[\s.:\)-]\s*(.+)$/);
      if (khopPA && cauHienTai) {
        var sao = khopPA[1];
        var chu = khopPA[2].toUpperCase();
        var noiDungPA = khopPA[3];
        var paIdx = chu.charCodeAt(0) - 65; // A=0, B=1...
        cauHienTai.phuongAn.push(noiDungPA);
        if (sao === "*") {
          cauHienTai.dapAn = cauHienTai.phuongAn.length - 1;
        }
        continue;
      }

      // Nhận diện dòng Đáp án: ...
      var khopDA = d.match(/^(?:Đáp án|ĐA|Answer|Key)[\s.:\)-]+\s*([A-Da-d0-3])/i);
      if (khopDA && cauHienTai) {
        var kyTu = khopDA[1].toUpperCase();
        if (kyTu >= "A" && kyTu <= "D") {
          cauHienTai.dapAn = kyTu.charCodeAt(0) - 65;
        } else if (kyTu >= "0" && kyTu <= "3") {
          cauHienTai.dapAn = parseInt(kyTu, 10);
        }
        continue;
      }

      // Nhận diện Giải thích: ...
      var khopGT = d.match(/^(?:Giải thích|Gợi ý|Explain)[\s.:\)-]+\s*(.+)$/i);
      if (khopGT && cauHienTai) {
        cauHienTai.giaiThich = khopGT[1];
        continue;
      }

      // Nếu là dòng tiếp nối câu hỏi
      if (cauHienTai && cauHienTai.phuongAn.length === 0) {
        cauHienTai.hoi += " " + d;
      }
    }

    if (cauHienTai && cauHienTai.phuongAn.length >= 2) {
      ketQua.push(chuanHoaCau(cauHienTai));
    }
    return ketQua;
  }

  function chuanHoaCau(c) {
    while (c.phuongAn.length < 4) {
      c.phuongAn.push("Phương án " + CHU[c.phuongAn.length]);
    }
    c.dapAn = gioiHan(c.dapAn, 0, c.phuongAn.length - 1);
    return c;
  }

  function veDanhSachCauTrongModal() {
    var c = $("dsCauHoiHienTai");
    var ds = (deTuTao && deTuTao.cauHoi) ? deTuTao.cauHoi : DS_CAU;
    $("demSoCauHoi").textContent = ds.length;
    c.innerHTML = "";

    if (!ds.length) {
      c.innerHTML = '<div style="text-align: center; color: var(--chu-mo); padding: 14px;">Chưa có câu hỏi nào. Bạn có thể dán đề nhanh hoặc thêm từng câu ở trên!</div>';
      return;
    }

    ds.forEach(function (cau, idx) {
      var it = document.createElement("div");
      it.className = "the-cau-hoi-con";
      it.innerHTML =
        '<div class="noi-dung-cau">' +
          '<strong>Câu ' + (idx + 1) + ': ' + cau.hoi + '</strong><br>' +
          '<small style="color: var(--xanh-sang);">✓ Đáp án ' + CHU[cau.dapAn] + ': ' + (cau.phuongAn[cau.dapAn] || "") + '</small>' +
        '</div>' +
        '<button class="nut-xoa-cau" type="button" title="Xóa câu này">✕</button>';

      it.querySelector(".nut-xoa-cau").addEventListener("click", function () {
        xoaCauHoiKhoiDe(idx);
      });
      c.appendChild(it);
    });
  }

  function xoaCauHoiKhoiDe(idx) {
    var ds = (deTuTao && deTuTao.cauHoi) ? deTuTao.cauHoi : DS_CAU.slice();
    ds.splice(idx, 1);
    luuDeTuTao(ds);
    veDanhSachCauTrongModal();
  }

  function luuDeTuTao(danhSach) {
    deTuTao = {
      tieuDe: "Đề Tự Tạo Của Tôi",
      monLop: "Đề Tùy Biến",
      thoiGianMoiCau: 20,
      diemMoiCau: 10,
      cauHoi: danhSach
    };
    luuStorage(KHOA_LUU_DE_RIENG, deTuTao);
    doiGoiLop("tu-nhap", true);
  }

  /* Gắn sự kiện giao diện */
  function khoiTaoSuKien() {
    // Thanh đầu
    $("chonLop").addEventListener("change", function () {
      doiGoiLop(this.value);
    });
    $("nutNhapCauHoi").addEventListener("click", function () {
      moModalNhap(true);
    });
    $("nutDongModal").addEventListener("click", dongModalNhap);
    $("nutDongVaChoi").addEventListener("click", dongModalNhap);

    $("nutAm").addEventListener("click", doiAm);
    $("nutToanManHinh").addEventListener("click", batTatToanManHinh);

    // Màn chuẩn bị
    $("soDoi").addEventListener("change", function () {
      S.soDoi = parseInt(this.value, 10);
      veOdoi();
      luuCauHinh();
    });
    $("thoiGian").addEventListener("input", function () { S.giay = parseInt(this.value, 10) || 20; luuCauHinh(); });
    $("diemMoiCau").addEventListener("input", function () { S.diem = parseInt(this.value, 10) || 10; luuCauHinh(); });
    $("xaoTron").addEventListener("change", function () { S.xaoTron = this.checked; luuCauHinh(); });
    $("tuDongDapAn").addEventListener("change", function () { S.tuDongDapAn = this.checked; luuCauHinh(); });
    $("nutBatDau").addEventListener("click", batDauChoi);

    // Màn câu hỏi
    $("nutDungGio").addEventListener("click", tamDungHoacChay);
    $("nutHienDapAn").addEventListener("click", moDapAn);
    $("nutTiep").addEventListener("click", tiepTheo);

    // Màn kết thúc
    $("nutChoiLai").addEventListener("click", batDauChoi);
    $("nutDoiLop").addEventListener("click", function () { hienMan("manBatDau"); });

    // Tabs modal
    $("tabDanVanBan").addEventListener("click", function () { chuyenTab("dan"); });
    $("tabDanhSachCau").addEventListener("click", function () { chuyenTab("danhsach"); });

    // Nạp đề từ text
    $("nutPhanTichDe").addEventListener("click", function () {
      var txt = $("txtVanBanDe").value;
      var ds = phanTichVanBanDe(txt);
      if (!ds.length) {
        alert("Không nhận diện được câu hỏi nào trong nội dung đã dán! Vui lòng kiểm tra định dạng mẫu.");
        return;
      }
      luuDeTuTao(ds);
      dongModalNhap();
      alert("Đã nạp thành công " + ds.length + " câu hỏi vào 'Đề Tự Tạo Của Tôi'!");
    });

    // Mẫu thử nghiệm
    $("nutNapViDu").addEventListener("click", function () {
      $("txtVanBanDe").value =
        "Câu 1: Hình bình hành có hai đường chéo vuông góc với nhau là hình gì?\n" +
        "A. Hình chữ nhật\n" +
        "B. Hình thoi\n" +
        "C. Hình thang vuông\n" +
        "D. Hình tròn\n" +
        "Đáp án: B\n" +
        "Giải thích: Dấu hiệu nhận biết hình thoi: Hình bình hành có hai đường chéo vuông góc là hình thoi.\n\n" +
        "Câu 2: Đơn vị đo tần số trong hệ SI là gì?\n" +
        "A. Hertz (Hz)\n" +
        "B. Newton (N)\n" +
        "C. Pascal (Pa)\n" +
        "D. Joule (J)\n" +
        "Đáp án: A\n" +
        "Giải thích: Đơn vị đo tần số dao động là Hertz (Hz).\n\n" +
        "Câu 3: Kim loại nào nhẹ nhất trong tất cả các kim loại?\n" +
        "A. Nhôm (Al)\n" +
        "B. Liti (Li)\n" +
        "C. Magie (Mg)\n" +
        "D. Kali (K)\n" +
        "Đáp án: B\n" +
        "Giải thích: Liti (Li) có khối lượng riêng chỉ 0,534 g/cm3, là kim loại nhẹ nhất.";
    });

    $("nutXoaTrang").addEventListener("click", function () {
      $("txtVanBanDe").value = "";
    });

    // Thêm từng câu hỏi thủ công
    $("nutLuuCauHoi").addEventListener("click", function () {
      var hoi = $("formHoi").value.trim();
      var pa0 = $("formPA0").value.trim();
      var pa1 = $("formPA1").value.trim();
      var pa2 = $("formPA2").value.trim();
      var pa3 = $("formPA3").value.trim();
      var da = parseInt($("formDapAn").value, 10) || 0;
      var gt = $("formGiaiThich").value.trim();

      if (!hoi || !pa0 || !pa1) {
        alert("Vui lòng nhập nội dung câu hỏi và ít nhất 2 phương án A, B!");
        return;
      }
      var ds = (deTuTao && deTuTao.cauHoi) ? deTuTao.cauHoi.slice() : DS_CAU.slice();
      ds.push({
        hoi: hoi,
        phuongAn: [pa0, pa1, pa2 || "Phương án C", pa3 || "Phương án D"],
        dapAn: da,
        giaiThich: gt
      });
      luuDeTuTao(ds);
      $("formHoi").value = "";
      $("formPA0").value = ""; $("formPA1").value = ""; $("formPA2").value = ""; $("formPA3").value = "";
      $("formGiaiThich").value = "";
      veDanhSachCauTrongModal();
    });

    // Xuất file JSON
    $("nutXuatFile").addEventListener("click", function () {
      var dataStr = "data:text/json;charset=utf-8," + encodeURIComponent(JSON.stringify(duLieuHienTai, null, 2));
      var dl = document.createElement("a");
      dl.setAttribute("href", dataStr);
      dl.setAttribute("download", (duLieuHienTai.tieuDe || "de-trac-nghiem") + ".json");
      dl.click();
    });

    // Nhập file JSON
    $("inpFileDe").addEventListener("change", function (e) {
      var file = e.target.files[0];
      if (!file) return;
      var reader = new FileReader();
      reader.onload = function (ev) {
        try {
          var obj = JSON.parse(ev.target.result);
          if (obj.cauHoi && Array.isArray(obj.cauHoi)) {
            deTuTao = obj;
            luuStorage(KHOA_LUU_DE_RIENG, deTuTao);
            doiGoiLop("tu-nhap", true);
            alert("Đã nhập thành công tệp đề gồm " + obj.cauHoi.length + " câu hỏi!");
            dongModalNhap();
          } else {
            alert("Tệp JSON không đúng định dạng chứa danh sách câu hỏi!");
          }
        } catch (err) {
          // Thử phân tích như text
          var ds = phanTichVanBanDe(ev.target.result);
          if (ds.length > 0) {
            luuDeTuTao(ds);
            alert("Đã nạp thành công " + ds.length + " câu hỏi từ tệp văn bản!");
            dongModalNhap();
          } else {
            alert("Không thể đọc tệp: " + err.message);
          }
        }
      };
      reader.readAsText(file, "UTF-8");
      this.value = "";
    });

    // Đặt lại mặc định
    $("nutKhoiPhucMacDinh").addEventListener("click", function () {
      if (confirm("Thầy/cô có chắc muốn đặt lại đề tự tạo về danh sách rỗng?")) {
        deTuTao = null;
        try { localStorage.removeItem(KHOA_LUU_DE_RIENG); } catch (e) {}
        doiGoiLop("lop-8");
        veDanhSachCauTrongModal();
      }
    });

    // Phím tắt bàn phím
    document.addEventListener("keydown", function (e) {
      if (!$("modalNhapCauHoi").hidden) return; // Đang mở modal thì không nhận phím tắt trò chơi
      var key = e.key.toUpperCase();
      if (key === "M") { doiAm(); return; }
      if (key === "F") { batTatToanManHinh(); return; }

      var manHoi = $("manHoi");
      if (manHoi && !manHoi.hidden) {
        if (key === "1" || key === "A") { traLoiPhuongAn(0); return; }
        if (key === "2" || key === "B") { traLoiPhuongAn(1); return; }
        if (key === "3" || key === "C") { traLoiPhuongAn(2); return; }
        if (key === "4" || key === "D") { traLoiPhuongAn(3); return; }
        if (e.code === "Space") { e.preventDefault(); moDapAn(); return; }
        if (e.key === "Enter") { e.preventDefault(); tiepTheo(); return; }
      }
    });
  }

  /* Khởi động app */
  function khoiDong() {
    khoiTaoSuKien();
    $("chonLop").value = maLopHienTai;
    duLieuHienTai = layDuLieuLop(maLopHienTai);
    DS_CAU = duLieuHienTai.cauHoi || [];
    capNhatTieuDeLop();
    veCauHinh();
  }

  khoiDong();
})();
