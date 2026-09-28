/* Thẻ ghi nhớ (flashcard) - phần mã chạy hỗ trợ đa lớp, tự nhập thẻ & gõ trả lời. */
(function () {
  "use strict";

  var NGAN_HANG = window.NGAN_HANG_FLASHCARD || {};
  var D_GOC = window.DU_LIEU || {};

  function $(id) { return document.getElementById(id); }

  /* ---------- Lưu tạm cấu hình ---------- */
  var KHOA_LUU_LOP = "flashcard:lop-da-chon";
  var KHOA_LUU_TU_NHAP = "flashcard:de-tu-nhap";

  function docStorage(khoa, macDinh) {
    try { var s = localStorage.getItem(khoa); return s ? JSON.parse(s) : macDinh; } catch (e) { return macDinh; }
  }
  function luuStorage(khoa, giaTri) {
    try { localStorage.setItem(khoa, JSON.stringify(giaTri)); } catch (e) { /* bỏ qua */ }
  }

  /* ---------- Âm thanh ---------- */
  var amCtx = null, tatTieng = false;
  function beep(tanSo, thoiGian, amLuong, treo) {
    if (tatTieng) return;
    try {
      if (!amCtx) { var AC = window.AudioContext || window.webkitAudioContext; if (!AC) return; amCtx = new AC(); }
      if (amCtx.state === "suspended") amCtx.resume();
      var t0 = amCtx.currentTime + (treo || 0), o = amCtx.createOscillator(), g = amCtx.createGain();
      o.frequency.value = tanSo;
      g.gain.setValueAtTime(0.0001, t0);
      g.gain.exponentialRampToValueAtTime(amLuong || 0.2, t0 + 0.02);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
      o.connect(g); g.connect(amCtx.destination); o.start(t0); o.stop(t0 + thoiGian + 0.05);
    } catch (e) { /* bỏ qua */ }
  }
  var AM = {
    lat: function () { beep(440, 0.08, 0.15); },
    thuoc: function () { beep(660, 0.12, 0.2); beep(880, 0.2, 0.25, 0.1); },
    chuyen: function () { beep(523, 0.06, 0.12); },
    dung: function () { beep(660, 0.15, 0.3); beep(880, 0.2, 0.3, 0.12); beep(1320, 0.3, 0.3, 0.24); },
    sai: function () { beep(260, 0.25, 0.2); }
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

  function xaoTron(mang) {
    for (var i = mang.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = mang[i]; mang[i] = mang[j]; mang[j] = t;
    }
    return mang;
  }

  /* ---------- Quản lý dữ liệu thẻ ---------- */
  var maLopHienTai = docStorage(KHOA_LUU_LOP, "lop-8");
  var theTuNhap = docStorage(KHOA_LUU_TU_NHAP, null);
  var D = D_GOC;
  var THE = [];

  function khoaThe(t) { return String(t.truoc) + "|" + String(t.sau); }

  function layDuLieuThe(maLop) {
    if (maLop === "tu-nhap") {
      if (theTuNhap && Array.isArray(theTuNhap.the) && theTuNhap.the.length > 0) {
        return theTuNhap;
      }
      return {
        tieuDe: "Bộ Thẻ Tự Tạo Của Tôi",
        monLop: "Tự tạo",
        the: [
          { nhan: "Mẫu", truoc: "Bấm 'Tự nhập thẻ' để thêm câu hỏi riêng", sau: "Thầy cô có thể dán hàng loạt thẻ rất nhanh!" }
        ]
      };
    }
    if (NGAN_HANG[maLop]) {
      return NGAN_HANG[maLop];
    }
    return NGAN_HANG["lop-8"] || D_GOC;
  }

  var daThuoc = {};
  var S = {
    thuTu: [],
    viTri: 0,
    chiChuaThuoc: false
  };

  function taiBoThe(maLop) {
    maLopHienTai = maLop;
    luuStorage(KHOA_LUU_LOP, maLop);
    $("chonLop").value = maLop;

    D = layDuLieuThe(maLop);
    THE = Array.isArray(D.the) ? D.the : [];

    var khoaStorageThuoc = "flashcard:thuoc:" + maLop;
    daThuoc = {};
    docStorage(khoaStorageThuoc, []).forEach(function (k) { daThuoc[k] = true; });

    S.thuTu = THE.map(function (_, i) { return i; });
    S.viTri = 0;
    S.chiChuaThuoc = false;
    $("nutLoc").classList.remove("bat");

    document.title = D.tieuDe || "Thẻ ghi nhớ";
    $("tieuDe").textContent = "🎴 " + (D.tieuDe || "Thẻ ghi nhớ");
    $("monLop").textContent = D.monLop || "";
    $("inpTraLoiThu").value = "";

    ve();
  }

  function danhSachDangOn() {
    if (!S.chiChuaThuoc) return S.thuTu;
    return S.thuTu.filter(function (i) { return !daThuoc[khoaThe(THE[i])]; });
  }
  function soDaThuoc() {
    return THE.filter(function (t) { return daThuoc[khoaThe(t)]; }).length;
  }

  function ve() {
    var ds = danhSachDangOn();
    var the = $("the");
    if (the.classList.contains("lat")) {
      the.classList.add("tuc-thi");
      the.classList.remove("lat");
      void the.offsetWidth;
      the.classList.remove("tuc-thi");
    }
    $("thongBao").hidden = true;
    $("inpTraLoiThu").value = "";

    if (!THE.length) {
      $("matTruoc").textContent = "Chưa có thẻ nào. Bấm 'Tự nhập thẻ' để thêm!";
      $("nhan").textContent = "";
      $("viTri").textContent = "";
      $("soThuoc").textContent = "";
      return;
    }
    if (!ds.length) {
      $("nhan").textContent = "🎉 Tuyệt vời!";
      $("matTruoc").textContent = "Đã thuộc hết tất cả các thẻ của phần này!";
      $("matSau").textContent = "";
      $("viTri").textContent = "Hoàn thành 100%";
      the.classList.remove("thuoc");
    } else {
      if (S.viTri >= ds.length) S.viTri = ds.length - 1;
      if (S.viTri < 0) S.viTri = 0;
      var t = THE[ds[S.viTri]];
      $("nhan").textContent = t.nhan || ("Thẻ #" + (S.viTri + 1));
      $("matTruoc").textContent = t.truoc || "";
      $("matSau").textContent = t.sau || "";
      $("matTruoc").classList.toggle("dai", (t.truoc || "").length > 60);
      $("matSau").classList.toggle("dai", (t.sau || "").length > 60);

      var thuoc = !!daThuoc[khoaThe(t)];
      the.classList.toggle("thuoc", thuoc);
      $("nutThuoc").classList.toggle("da", thuoc);
      $("nutThuoc").textContent = thuoc ? "✓ Đã thuộc" : "Đánh dấu thuộc";
      $("viTri").textContent = "Thẻ " + (S.viTri + 1) + " / " + ds.length;
    }

    $("soThuoc").textContent = "Đã thuộc: " + soDaThuoc() + " / " + THE.length;
    veCham(ds);
  }

  function veCham(ds) {
    var cham = $("cham");
    cham.innerHTML = "";
    if (ds.length > 40) return;
    ds.forEach(function (idxGoc, i) {
      var sp = document.createElement("span");
      if (daThuoc[khoaThe(THE[idxGoc])]) sp.classList.add("thuoc");
      if (i === S.viTri) sp.classList.add("dang");
      sp.addEventListener("click", function () { S.viTri = i; ve(); });
      cham.appendChild(sp);
    });
  }

  function lat() {
    var the = $("the");
    if (!danhSachDangOn().length) return;
    the.classList.toggle("lat");
    AM.lat();
  }

  function chuyen(delta) {
    var ds = danhSachDangOn();
    if (!ds.length) return;
    S.viTri = (S.viTri + delta + ds.length) % ds.length;
    AM.chuyen();
    ve();
  }

  function doiThuoc() {
    var ds = danhSachDangOn();
    if (!ds.length) return;
    var t = THE[ds[S.viTri]];
    var k = khoaThe(t);
    if (daThuoc[k]) {
      delete daThuoc[k];
    } else {
      daThuoc[k] = true;
      AM.thuoc();
    }
    luuStorage("flashcard:thuoc:" + maLopHienTai, Object.keys(daThuoc));
    ve();
  }

  function xaoTronThe() {
    xaoTron(S.thuTu);
    S.viTri = 0;
    thongBao("Đã xáo trộn ngẫu nhiên thứ tự các thẻ!");
    ve();
  }

  function batTatLoc() {
    S.chiChuaThuoc = !S.chiChuaThuoc;
    S.viTri = 0;
    $("nutLoc").classList.toggle("bat", S.chiChuaThuoc);
    thongBao(S.chiChuaThuoc ? "Chế độ: Chỉ hiển thị các thẻ chưa thuộc." : "Chế độ: Hiển thị tất cả các thẻ.");
    ve();
  }

  function thongBao(nd) {
    var tb = $("thongBao");
    tb.textContent = nd;
    tb.hidden = false;
    clearTimeout(tb._hen);
    tb._hen = setTimeout(function () { tb.hidden = true; }, 3000);
  }

  /* Học sinh gõ câu trả lời thử trước khi lật */
  function kiemTraCauTraLoiThu() {
    var ds = danhSachDangOn();
    if (!ds.length) return;
    var t = THE[ds[S.viTri]];
    var gopNhap = $("inpTraLoiThu").value.trim().toLowerCase();
    if (!gopNhap) {
      lat();
      return;
    }

    var dapAnDung = String(t.sau || "").trim().toLowerCase();
    // Bỏ dấu câu để so sánh gần đúng
    var a = gopNhap.replace(/[^\p{L}\p{N}]/gu, "");
    var b = dapAnDung.replace(/[^\p{L}\p{N}]/gu, "");

    $("the").classList.add("lat");

    if (a && b && (a === b || b.indexOf(a) >= 0 || a.indexOf(b) >= 0)) {
      AM.dung();
      thongBao("🎉 Hoan hô! Em đã trả lời rất chính xác!");
      daThuoc[khoaThe(t)] = true;
      luuStorage("flashcard:thuoc:" + maLopHienTai, Object.keys(daThuoc));
      setTimeout(ve, 1200);
    } else {
      AM.sai();
      thongBao("💡 Hãy đối chiếu đáp án ở mặt sau nhé!");
    }
  }

  /* ---------- Modal tự nhập thẻ ---------- */
  function moModalThe() {
    $("modalNhapThe").hidden = false;
  }
  function dongModalThe() {
    $("modalNhapThe").hidden = true;
  }

  function luuTheTuNhap() {
    var txt = $("txtVanBanThe").value.trim();
    if (!txt) { alert("Vui lòng nhập hoặc dán nội dung các thẻ!"); return; }

    var dong = txt.split(/\r?\n/);
    var dsThe = [];

    dong.forEach(function (d, idx) {
      d = d.trim();
      if (!d) return;
      var parts = d.split("|").map(function (s) { return s.trim(); });
      if (parts.length >= 2) {
        dsThe.push({ nhan: "Thẻ #" + (dsThe.length + 1), truoc: parts[0], sau: parts[1] });
      } else {
        // Nếu không có dấu |, lấy nửa đầu là trước, nửa sau là sau nếu có dấu hỏi (?)
        var hoiIdx = d.indexOf("?");
        if (hoiIdx > 0 && hoiIdx < d.length - 1) {
          dsThe.push({
            nhan: "Thẻ #" + (dsThe.length + 1),
            truoc: d.substring(0, hoiIdx + 1).trim(),
            sau: d.substring(hoiIdx + 1).trim()
          });
        }
      }
    });

    if (!dsThe.length) {
      alert("Không tách được thẻ nào! Vui lòng dùng định dạng: Mặt trước | Mặt sau");
      return;
    }

    theTuNhap = {
      tieuDe: "Bộ Thẻ Tự Tạo (" + dsThe.length + " thẻ)",
      monLop: "Tự tạo",
      the: dsThe
    };
    luuStorage(KHOA_LUU_TU_NHAP, theTuNhap);
    dongModalThe();
    taiBoThe("tu-nhap");
    alert("Đã lưu thành công " + dsThe.length + " thẻ ghi nhớ!");
  }

  /* Gắn sự kiện */
  function khoiTaoSuKien() {
    $("chonLop").addEventListener("change", function () {
      if (this.value === "tu-nhap" && (!theTuNhap || !theTuNhap.the || !theTuNhap.the.length)) {
        moModalThe();
      } else {
        taiBoThe(this.value);
      }
    });

    $("nutNhapThe").addEventListener("click", moModalThe);
    $("nutDongModal").addEventListener("click", dongModalThe);
    $("nutLuuBoThe").addEventListener("click", luuTheTuNhap);
    $("nutXoaTrangThe").addEventListener("click", function () { $("txtVanBanThe").value = ""; });

    $("nutNapViDuThe").addEventListener("click", function () {
      $("txtVanBanThe").value =
        "Kim loại nào nhẹ nhất thế giới? | Kim loại Liti (Li)\n" +
        "Số pi (π) xấp xỉ bằng bao nhiêu? | 3,14159...\n" +
        "Nước sôi ở bao nhiêu độ C ở áp suất thường? | 100°C\n" +
        "Ai phát minh ra bảng tuần hoàn các nguyên tố hóa học? | Dmitri Mendeleev\n" +
        "Công thức diện tích hình tròn bán kính r? | S = π · r²\n" +
        "Tác giả bài thơ 'Đồng chí'? | Chính Hữu";
    });

    $("the").addEventListener("click", lat);
    $("nutLat").addEventListener("click", lat);
    $("nutTruoc").addEventListener("click", function () { chuyen(-1); });
    $("nutSau").addEventListener("click", function () { chuyen(1); });
    $("nutThuoc").addEventListener("click", doiThuoc);
    $("nutXaoTron").addEventListener("click", xaoTronThe);
    $("nutLoc").addEventListener("click", batTatLoc);
    $("nutAm").addEventListener("click", doiAm);
    $("nutToanManHinh").addEventListener("click", batTatToanManHinh);

    $("nutKiemTraThu").addEventListener("click", kiemTraCauTraLoiThu);
    $("inpTraLoiThu").addEventListener("keydown", function (e) {
      if (e.key === "Enter") {
        e.preventDefault();
        kiemTraCauTraLoiThu();
      }
    });

    // Phím tắt
    document.addEventListener("keydown", function (e) {
      if (!$("modalNhapThe").hidden) return;
      if (e.target && e.target.id === "inpTraLoiThu") return;
      if (e.code === "Space") { e.preventDefault(); lat(); }
      else if (e.key === "ArrowLeft") { e.preventDefault(); chuyen(-1); }
      else if (e.key === "ArrowRight") { e.preventDefault(); chuyen(1); }
      else if (e.key === "Enter") { e.preventDefault(); doiThuoc(); }
      else if (e.key.toLowerCase() === "x") xaoTronThe();
      else if (e.key.toLowerCase() === "l") batTatLoc();
      else if (e.key.toLowerCase() === "m") doiAm();
      else if (e.key.toLowerCase() === "f") batTatToanManHinh();
    });
  }

  function khoiDong() {
    khoiTaoSuKien();
    taiBoThe(maLopHienTai);
  }

  khoiDong();
})();
