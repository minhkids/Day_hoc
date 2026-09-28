/* Ô chữ hàng ngang + từ khóa hàng dọc - phần mã chạy hỗ trợ đa lớp & tự tạo ô chữ. */
(function () {
  "use strict";

  var NGAN_HANG = window.NGAN_HANG_O_CHU || {};
  var D_GOC = window.DU_LIEU || {};

  function $(id) { return document.getElementById(id); }

  /* ---------- Chuẩn hóa chữ ---------- */
  function chuCai(s) {
    return String(s || "").normalize("NFC").toUpperCase().replace(/[^\p{L}\p{N}]/gu, "");
  }
  function boDau(s) {
    return s.normalize("NFD").replace(/\p{M}/gu, "").replace(/Đ/g, "D").replace(/đ/g, "d").replace(/Y/g, "I");
  }
  function khop(traLoi, dapAn) {
    var a = chuCai(traLoi), b = chuCai(dapAn);
    if (!a) return false;
    return a === b || boDau(a) === boDau(b);
  }

  /* ---------- Lưu trữ cấu hình & ô chữ tự tạo ---------- */
  var KHOA_LUU_LOP = "o-chu:lop-da-chon";
  var KHOA_LUU_TU_TAO = "o-chu:de-tu-tao";

  function docStorage(khoa, macDinh) {
    try { var s = localStorage.getItem(khoa); return s ? JSON.parse(s) : macDinh; } catch (e) { return macDinh; }
  }
  function luuStorage(khoa, giaTri) {
    try { localStorage.setItem(khoa, JSON.stringify(giaTri)); } catch (e) { /* bỏ qua */ }
  }

  /* ---------- Âm thanh ---------- */
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
    } catch (e) { /* bỏ qua */ }
  }
  var AM = {
    dung: function () { beep(660, 0.15, "sine", 0.35); beep(880, 0.15, "sine", 0.35, 0.12); beep(1320, 0.35, "sine", 0.35, 0.24); },
    sai: function () { beep(220, 0.35, "sawtooth", 0.2); beep(170, 0.45, "sawtooth", 0.2, 0.18); },
    goiY: function () { beep(523, 0.12, "sine", 0.25); beep(659, 0.15, "sine", 0.25, 0.1); },
    tuKhoa: function () { [523, 659, 784, 1047, 1319].forEach(function (f, i) { beep(f, 0.35, "triangle", 0.35, i * 0.14); }); }
  };
  function doiAm() {
    tatTieng = !tatTieng;
    $("nutAm").textContent = tatTieng ? "Âm thanh: Tắt" : "Âm thanh: Bật";
  }

  /* ---------- Toàn màn hình ---------- */
  function batTatToanManHinh() {
    var d = document, el = d.documentElement, p;
    try {
      if (!d.fullscreenElement && !d.webkitFullscreenElement) p = (el.requestFullscreen || el.webkitRequestFullscreen).call(el);
      else p = (d.exitFullscreen || d.webkitExitFullscreen).call(d);
      if (p && p.catch) p.catch(function () {});
    } catch (e) { /* bỏ qua */ }
  }

  /* ---------- Quản lý dữ liệu ô chữ ---------- */
  var maLopHienTai = docStorage(KHOA_LUU_LOP, "lop-8");
  var oChuTuTao = docStorage(KHOA_LUU_TU_TAO, null);
  var D = D_GOC;
  var KHOA = [], HANG = [], TRAI = 0, PHAI = 0, SO_COT = 0, canhBao = [];
  var S = { chon: -1, tuKhoaMo: false };

  function layDuLieuOChu(maLop) {
    if (maLop === "tu-tao") {
      if (oChuTuTao && oChuTuTao.tuKhoa && Array.isArray(oChuTuTao.hangNgang) && oChuTuTao.hangNgang.length > 0) {
        return oChuTuTao;
      }
      return {
        tieuDe: "Ô Chữ Tự Tạo Của Tôi",
        monLop: "Tự tạo",
        tuKhoa: "TOÁN HỌC",
        goiYTuKhoa: "Môn học của các con số và logic?",
        hangNgang: [
          { dapAn: "HÌNH VUÔNG", oKhoa: 8, goiY: "Tứ giác đều có 4 góc vuông và 4 cạnh bằng nhau?" },
          { dapAn: "ĐƠN THỨC", oKhoa: 2, goiY: "Biểu thức đại số chỉ gồm một số hoặc một tích?" },
          { dapAn: "PHÂN SỐ", oKhoa: 3, goiY: "Số có dạng tử số chia cho mẫu số?" },
          { dapAn: "HÀM SỐ", oKhoa: 1, goiY: "Quy tắc tương ứng mỗi x cho duy nhất một y?" },
          { dapAn: "GÓC VUÔNG", oKhoa: 2, goiY: "Góc có số đo bằng 90 độ?" },
          { dapAn: "ĐA THỨC", oKhoa: 5, goiY: "Tổng của nhiều đơn thức?" },
          { dapAn: "ĐẠI SỐ", oKhoa: 5, goiY: "Phần toán học nghiên cứu về phương trình, biến số?" }
        ]
      };
    }
    if (NGAN_HANG[maLop]) {
      return NGAN_HANG[maLop];
    }
    return NGAN_HANG["lop-8"] || D_GOC;
  }

  function taiDuLieu(maLop) {
    maLopHienTai = maLop;
    luuStorage(KHOA_LUU_LOP, maLop);
    $("chonLop").value = maLop;

    D = layDuLieuOChu(maLop);
    KHOA = Array.from(chuCai(D.tuKhoa));
    canhBao = [];

    HANG = (Array.isArray(D.hangNgang) ? D.hangNgang : []).map(function (h, i) {
      var chu = Array.from(chuCai(h.dapAn));
      var k = parseInt(h.oKhoa, 10) - 1;
      if (!(k >= 0 && k < chu.length)) k = chu.indexOf(KHOA[i]);
      if (k < 0) { k = 0; }
      if (KHOA[i] && chu[k] !== KHOA[i]) {
        canhBao.push("Hàng " + (i + 1) + ": chữ cái cột khóa là '" + (chu[k] || "?") + "', từ khóa cần '" + KHOA[i] + "'.");
      }
      return { chu: chu, khoa: k, goiY: h.goiY || "", dapAn: h.dapAn, mo: false, chuDaMo: {} };
    });

    TRAI = 0; PHAI = 0;
    HANG.forEach(function (h) {
      TRAI = Math.max(TRAI, h.khoa);
      PHAI = Math.max(PHAI, h.chu.length - h.khoa - 1);
    });
    SO_COT = TRAI + 1 + PHAI;

    S.chon = -1;
    S.tuKhoaMo = false;

    document.title = D.tieuDe || "Ô chữ";
    $("tieuDe").textContent = "🧩 " + (D.tieuDe || "Ô chữ");
    $("monLop").textContent = D.monLop || "";

    $("nhanHang").textContent = "Chọn một hàng ngang";
    $("goiY").textContent = "Bấm số thứ tự hàng ngang (hoặc phím 1, 2, 3...) để xem câu hỏi gợi ý.";
    $("oTraLoi").value = "";
    thongBao("");

    if (canhBao.length) {
      $("canhBaoDuLieu").textContent = "Lưu ý dữ liệu: " + canhBao.join(" ");
      $("canhBaoDuLieu").hidden = false;
    } else {
      $("canhBaoDuLieu").hidden = true;
    }

    dungLuoi();
    veLuoi();
  }

  /* ---------- Vẽ lưới ---------- */
  function dungLuoi() {
    var luoi = $("luoi");
    luoi.innerHTML = "";
    HANG.forEach(function (h, i) {
      var hang = document.createElement("div");
      hang.className = "hang";
      hang.setAttribute("data-i", i);
      var so = document.createElement("div");
      so.className = "so-hang"; so.textContent = i + 1;
      hang.appendChild(so);
      for (var t = 0; t < TRAI - h.khoa; t++) {
        var trong = document.createElement("div"); trong.className = "o-trong"; hang.appendChild(trong);
      }
      h.chu.forEach(function (c, j) {
        var o = document.createElement("div");
        o.className = "o" + (j === h.khoa ? " cot-khoa" : "");
        o.style.animationDelay = (j * 0.05) + "s";
        hang.appendChild(o);
      });
      hang.addEventListener("click", function () { chonHang(i); });
      luoi.appendChild(hang);
    });
    doKichThuoc();
  }

  function veLuoi() {
    var cacHang = $("luoi").children;
    HANG.forEach(function (h, i) {
      var hang = cacHang[i];
      if (!hang) return;
      hang.classList.toggle("chon", S.chon === i);
      hang.classList.toggle("mo", h.mo);
      var o = hang.querySelectorAll(".o");
      for (var j = 0; j < o.length; j++) {
        var laKhoa = j === h.khoa;
        var daMoRieng = !!h.chuDaMo[j];
        var hien = h.mo || (laKhoa && S.tuKhoaMo) || daMoRieng;
        o[j].textContent = hien ? h.chu[j] : "";
        o[j].classList.toggle("khoa-mo", laKhoa && (h.mo || S.tuKhoaMo));
      }
    });
    $("tuKhoaHien").textContent = S.tuKhoaMo
      ? String(D.tuKhoa || "").toUpperCase()
      : KHOA.map(function () { return "_"; }).join(" ") + " (" + KHOA.length + " chữ)";
    $("nutTuKhoa").classList.toggle("chon", S.chon === -2);
  }

  function doKichThuoc() {
    var vung = $("vungLuoi");
    var soHang = Math.max(1, HANG.length);
    var theoNgang = (vung.clientWidth - 20) / (SO_COT + 1.3) - 4;
    var theoDoc = (vung.clientHeight - 6 * soHang) / soHang;
    var o = Math.floor(Math.max(24, Math.min(68, theoNgang, theoDoc)));
    $("luoi").style.setProperty("--o", o + "px");
  }

  /* ---------- Tương tác giải ô chữ ---------- */
  function thongBao(chu, loai) {
    var tb = $("thongBao");
    tb.textContent = chu || "";
    tb.className = "thong-bao" + (loai ? " " + loai : "");
  }

  function chonHang(i) {
    if (i < 0 || i >= HANG.length) return;
    S.chon = i;
    var h = HANG[i];
    $("nhanHang").textContent = "Hàng ngang " + (i + 1) + " · " + h.chu.length + " chữ cái";
    $("goiY").textContent = h.goiY;
    $("oTraLoi").value = h.mo ? String(h.dapAn).toUpperCase() : "";
    thongBao(h.mo ? "✓ Hàng này đã được mở." : "", h.mo ? "dung" : "");
    $("oTraLoi").focus();
    veLuoi();
  }

  function chonTuKhoa() {
    S.chon = -2;
    $("nhanHang").textContent = "Từ khóa hàng dọc · " + KHOA.length + " chữ cái";
    $("goiY").textContent = D.goiYTuKhoa || "Đoán từ khóa hàng dọc từ các chữ cái ở cột màu vàng.";
    $("oTraLoi").value = S.tuKhoaMo ? String(D.tuKhoa).toUpperCase() : "";
    thongBao(S.tuKhoaMo ? "✓ Từ khóa đã được mở." : "", S.tuKhoaMo ? "dung" : "");
    $("oTraLoi").focus();
    veLuoi();
  }

  function kiemTra() {
    var traLoi = $("oTraLoi").value;
    if (S.chon === -1) { thongBao("Hãy chọn một hàng ngang trước.", "sai"); return; }
    if (!chuCai(traLoi)) { thongBao("Chưa nhập câu trả lời của học sinh.", "sai"); return; }
    if (S.chon === -2) {
      if (khop(traLoi, D.tuKhoa)) { moTuKhoa(); }
      else { AM.sai(); thongBao("Chưa chính xác, các em thử suy nghĩ lại nhé!", "sai"); }
      return;
    }
    var h = HANG[S.chon];
    if (khop(traLoi, h.dapAn)) { moHang(S.chon); }
    else {
      AM.sai();
      thongBao("Chưa chính xác, thử lại nhé!", "sai");
      var hang = $("luoi").children[S.chon];
      if (hang) {
        hang.classList.remove("sai"); void hang.offsetWidth; hang.classList.add("sai");
      }
    }
  }

  function moHang(i) {
    var h = HANG[i];
    if (!h || h.mo) return;
    h.mo = true;
    AM.dung();
    $("oTraLoi").value = String(h.dapAn).toUpperCase();
    thongBao("🎉 Đúng rồi! Đáp án: " + String(h.dapAn).toUpperCase(), "dung");
    veLuoi();
  }

  function moTuKhoa() {
    if (S.tuKhoaMo) return;
    S.tuKhoaMo = true;
    AM.tuKhoa();
    $("oTraLoi").value = String(D.tuKhoa).toUpperCase();
    thongBao("🏆 CHÚC MỪNG! Đã giải được từ khóa: " + String(D.tuKhoa).toUpperCase(), "dung");
    veLuoi();
  }

  function moDapAn() {
    if (S.chon === -2) moTuKhoa();
    else if (S.chon >= 0) moHang(S.chon);
    else thongBao("Hãy chọn một hàng ngang trước.", "sai");
  }

  /* Gợi ý mở 1 chữ cái chưa mở trong hàng */
  function goiYChuCai() {
    if (S.chon < 0 || S.chon >= HANG.length) {
      thongBao("Vui lòng chọn 1 hàng ngang để nhận gợi ý!", "sai");
      return;
    }
    var h = HANG[S.chon];
    if (h.mo) {
      thongBao("Hàng này đã mở toàn bộ!", "dung");
      return;
    }
    var dsChuaMo = [];
    for (var j = 0; j < h.chu.length; j++) {
      if (!h.chuDaMo[j] && !(j === h.khoa && S.tuKhoaMo)) {
        dsChuaMo.push(j);
      }
    }
    if (!dsChuaMo.length) {
      moHang(S.chon);
      return;
    }
    var randomIdx = dsChuaMo[Math.floor(Math.random() * dsChuaMo.length)];
    h.chuDaMo[randomIdx] = true;
    AM.goiY();
    thongBao("💡 Đã mở gợi ý chữ cái: " + h.chu[randomIdx], "dung");
    veLuoi();
  }

  /* ---------- Modal tự tạo ô chữ ---------- */
  function moModalTao() {
    $("modalTaoOChu").hidden = false;
    veFormTaoHang();
  }
  function dongModalTao() {
    $("modalTaoOChu").hidden = true;
  }

  function veFormTaoHang() {
    var c = $("danhSachHangTao");
    c.innerHTML = "";
    var tuKhoa = $("inpTuKhoa").value.trim() || (D.tuKhoa || "TOÁN HỌC");
    var chuKhoa = Array.from(chuCai(tuKhoa));
    var hangCu = (D.hangNgang || []);

    chuKhoa.forEach(function (ch, idx) {
      var cu = hangCu[idx] || {};
      var div = document.createElement("div");
      div.className = "dong-hang-tao";
      div.innerHTML =
        '<span class="stt">#' + (idx + 1) + ' [' + ch + ']</span>' +
        '<input type="text" class="da" placeholder="Đáp án hàng ' + (idx + 1) + '" value="' + (cu.dapAn || "") + '">' +
        '<input type="text" class="gy" placeholder="Câu hỏi gợi ý..." value="' + (cu.goiY || "") + '">';
      c.appendChild(div);
    });
  }

  function luuOChuTuTao() {
    var tk = $("inpTuKhoa").value.trim();
    var gyTk = $("inpGoiYTuKhoa").value.trim();
    if (!tk) { alert("Vui lòng nhập Từ khóa hàng dọc!"); return; }

    var chuKhoa = Array.from(chuCai(tk));
    var cacDong = $("danhSachHangTao").querySelectorAll(".dong-hang-tao");
    var hangMoi = [];

    for (var i = 0; i < cacDong.length; i++) {
      var inpDA = cacDong[i].querySelector(".da");
      var inpGY = cacDong[i].querySelector(".gy");
      var da = inpDA.value.trim();
      var gy = inpGY.value.trim() || ("Gợi ý cho hàng " + (i + 1));
      if (!da) {
        alert("Vui lòng nhập đáp án cho hàng ngang số " + (i + 1) + "!");
        return;
      }
      // Tự động tìm vị trí chữ cái chung
      var chuH = Array.from(chuCai(da));
      var canTim = chuKhoa[i];
      var viTri = chuH.indexOf(canTim);
      if (viTri < 0) {
        // Thử tìm theo không dấu
        var canTimKhongDau = boDau(canTim);
        for (var j = 0; j < chuH.length; j++) {
          if (boDau(chuH[j]) === canTimKhongDau) { viTri = j; break; }
        }
      }
      if (viTri < 0) {
        alert("Đáp án hàng " + (i + 1) + " ('" + da + "') phải chứa chữ cái '" + canTim + "' của từ khóa!");
        return;
      }
      hangMoi.push({ dapAn: da.toUpperCase(), oKhoa: viTri + 1, goiY: gy });
    }

    oChuTuTao = {
      tieuDe: "Ô Chữ: " + tk.toUpperCase(),
      monLop: "Đề tự tạo",
      tuKhoa: tk.toUpperCase(),
      goiYTuKhoa: gyTk || "Đoán từ khóa hàng dọc từ cột màu vàng.",
      hangNgang: hangMoi
    };
    luuStorage(KHOA_LUU_TU_TAO, oChuTuTao);
    dongModalTao();
    taiDuLieu("tu-tao");
    alert("Đã tạo ô chữ thành công!");
  }

  /* Gắn sự kiện */
  function khoiTaoSuKien() {
    $("chonLop").addEventListener("change", function () {
      if (this.value === "tu-tao" && !oChuTuTao) {
        moModalTao();
      } else {
        taiDuLieu(this.value);
      }
    });

    $("nutTaoOChu").addEventListener("click", moModalTao);
    $("nutDongModal").addEventListener("click", dongModalTao);
    $("nutAm").addEventListener("click", doiAm);
    $("nutToanManHinh").addEventListener("click", batTatToanManHinh);

    $("nutKiemTra").addEventListener("click", kiemTra);
    $("nutMo").addEventListener("click", moDapAn);
    $("nutGoiYChu").addEventListener("click", goiYChuCai);
    $("nutTuKhoa").addEventListener("click", chonTuKhoa);

    $("inpTuKhoa").addEventListener("input", veFormTaoHang);
    $("nutLuuOChu").addEventListener("click", luuOChuTuTao);

    $("nutNapMauOChu").addEventListener("click", function () {
      $("inpTuKhoa").value = "HỌC TẬP";
      $("inpGoiYTuKhoa").value = "Hoạt động chính của học sinh để tiếp thu tri thức?";
      veFormTaoHang();
      var cacDong = $("danhSachHangTao").querySelectorAll(".dong-hang-tao");
      var mau = [
        { da: "HÌNH HỌC", gy: "Nhánh toán học nghiên cứu về không gian, hình khối, góc?" },
        { da: "ĐỒ THỊ", gy: "Đường biểu diễn sự biến thiên của hàm số trên mặt phẳng tọa độ?" },
        { da: "CĂN BẬC HAI", gy: "Số x sao cho x bình phương bằng a?" },
        { da: "TỨ GIÁC", gy: "Hình đa giác có đúng 4 đỉnh và 4 cạnh?" },
        { da: "HẰNG SỐ", gy: "Đại lượng có giá trị không thay đổi trong quá trình tính toán?" },
        { da: "PHƯƠNG TRÌNH", gy: "Mệnh đề chứa biến có dạng f(x) = g(x)?" }
      ];
      cacDong.forEach(function (d, i) {
        if (mau[i]) {
          d.querySelector(".da").value = mau[i].da;
          d.querySelector(".gy").value = mau[i].gy;
        }
      });
    });

    window.addEventListener("resize", doKichThuoc);

    // Phím tắt
    document.addEventListener("keydown", function (e) {
      if (!$("modalTaoOChu").hidden) return;
      if (e.ctrlKey || e.altKey || e.metaKey) return;
      var t = e.target;
      if (t && t.tagName === "INPUT") {
        if (e.key === "Enter") { e.preventDefault(); kiemTra(); }
        else if (e.key === "Escape") t.blur();
        return;
      }
      var k = e.key.length === 1 ? e.key.toLowerCase() : e.key;
      if (/^[1-9]$/.test(k)) { chonHang(+k - 1); }
      else if (k === "k") chonTuKhoa();
      else if (k === "o") moDapAn();
      else if (k === "m") doiAm();
      else if (k === "f") batTatToanManHinh();
      else if (k === "Enter") { e.preventDefault(); if (S.chon !== -1) $("oTraLoi").focus(); }
      else if (k === "ArrowDown") { e.preventDefault(); chonHang(Math.min(HANG.length - 1, S.chon + 1)); }
      else if (k === "ArrowUp") { e.preventDefault(); chonHang(Math.max(0, S.chon - 1)); }
    });
  }

  function khoiDong() {
    khoiTaoSuKien();
    taiDuLieu(maLopHienTai);
  }

  khoiDong();
})();
