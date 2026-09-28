/* Vòng quay gọi tên / chọn chủ đề - phần mã chạy hỗ trợ đa lớp & câu đố. */
(function () {
  "use strict";

  var NGAN_HANG = window.NGAN_HANG_VONG_QUAY || {};
  var D_GOC = window.DU_LIEU || {};
  var MAU = ["#F2C94C", "#2F7A5A", "#E85D4A", "#3B6FB6", "#8E6FD1", "#E08A3C", "#1F9AA0", "#C2477A"];
  var MAU_CHU_TOI = { "#F2C94C": true, "#E08A3C": true };

  function $(id) { return document.getElementById(id); }

  /* ---------- Lưu tạm ---------- */
  var KHOA_LUU_LOP = "vong-quay:lop-da-chon";
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
      g.gain.exponentialRampToValueAtTime(amLuong || 0.2, t0 + 0.01);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
      o.connect(g); g.connect(amCtx.destination); o.start(t0); o.stop(t0 + thoiGian + 0.05);
    } catch (e) { /* bỏ qua */ }
  }
  function amTich() { beep(1400, 0.03, "square", 0.08); }
  function amKetQua() { [523, 659, 784, 1047].forEach(function (f, i) { beep(f, 0.3, "triangle", 0.3, i * 0.12); }); }
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

  /* ---------- Trạng thái ---------- */
  var maLopHienTai = docStorage(KHOA_LUU_LOP, "lop-8");
  var D = NGAN_HANG[maLopHienTai] || D_GOC;

  var S = {
    muc: [],
    daQuay: [],
    goc: 0,
    dangQuay: false,
    trung: -1,
    kichThuoc: 400
  };
  var canvas = $("vong"), ctx = canvas.getContext("2d");

  function docOVanBan() {
    return $("oDanhSach").value.split(/\r?\n/)
      .map(function (s) { return s.trim(); })
      .filter(function (s) { return s.length > 0; });
  }

  function capNhatOVanBan(ds) {
    $("oDanhSach").value = ds.join("\n");
  }

  function taiGoiLop(maLop) {
    maLopHienTai = maLop;
    luuStorage(KHOA_LUU_LOP, maLop);
    $("chonLop").value = maLop;

    D = NGAN_HANG[maLop] || D_GOC;
    document.title = D.tieuDe || "Vòng quay";
    $("tieuDe").textContent = "🎯 " + (D.tieuDe || "Vòng quay");
    $("monLop").textContent = D.monLop || "";
    $("loaiTen").checked = (D.loaiSauKhiQuay !== false);

    S.muc = Array.isArray(D.danhSach) ? D.danhSach.slice() : [];
    S.daQuay = [];
    capNhatOVanBan(S.muc);
    capNhatDaQuay();
    ve();
  }

  /* ---------- Vẽ vòng quay ---------- */
  function doKichThuoc() {
    var vung = $("vungVong");
    var kt = Math.floor(Math.min(vung.clientWidth, vung.clientHeight) - 60);
    kt = Math.max(220, kt);
    S.kichThuoc = kt;
    var khung = $("khungVong");
    khung.style.width = kt + "px";
    khung.style.height = kt + "px";
    var tl = window.devicePixelRatio || 1;
    canvas.width = Math.round(kt * tl);
    canvas.height = Math.round(kt * tl);
    ctx.setTransform(tl, 0, 0, tl, 0, 0);
    ve();
  }

  function ve() {
    var kt = S.kichThuoc, r = kt / 2, n = S.muc.length;
    ctx.clearRect(0, 0, kt, kt);
    ctx.save();
    ctx.translate(r, r);
    if (!n) {
      ctx.fillStyle = "#243A66";
      ctx.beginPath(); ctx.arc(0, 0, r, 0, Math.PI * 2); ctx.fill();
      ctx.fillStyle = "#B9C4DA";
      ctx.font = "600 " + Math.round(kt * 0.045) + "px 'Segoe UI', system-ui, sans-serif";
      ctx.textAlign = "center";
      ctx.fillText("Hết danh sách - bấm Đặt lại", 0, -r * 0.45);
      ctx.restore();
      return;
    }
    var cung = Math.PI * 2 / n;
    for (var i = 0; i < n; i++) {
      var batDau = S.goc + i * cung;
      var mau = MAU[i % MAU.length];
      if (i === n - 1 && n > 1 && n % MAU.length === 1) mau = MAU[3];
      ctx.beginPath();
      ctx.moveTo(0, 0);
      ctx.arc(0, 0, r, batDau, batDau + cung);
      ctx.closePath();
      ctx.fillStyle = mau;
      ctx.fill();
      ctx.strokeStyle = "rgba(20,33,61,.55)";
      ctx.lineWidth = 2;
      ctx.stroke();

      ctx.save();
      ctx.rotate(batDau + cung / 2);
      ctx.textAlign = "right";
      ctx.textBaseline = "middle";
      ctx.fillStyle = MAU_CHU_TOI[mau] ? "#14213D" : "#FFFFFF";
      var coChu = Math.round(Math.max(12, Math.min(26, (kt * 0.45) / Math.max(8, n) * 1.8)));
      ctx.font = "700 " + coChu + "px 'Segoe UI', system-ui, sans-serif";
      var chu = S.muc[i];
      if (chu.length > 22) chu = chu.slice(0, 20) + "...";
      ctx.fillText(chu, r - 20, 0);
      ctx.restore();
    }
    ctx.restore();
  }

  /* ---------- Chạy quay ---------- */
  function quay() {
    if (S.dangQuay || S.muc.length === 0) return;
    S.dangQuay = true;
    $("nutQuay").disabled = true;

    var n = S.muc.length;
    var chiSo = Math.floor(Math.random() * n);
    var cung = Math.PI * 2 / n;
    var gocMuc = chiSo * cung + cung / 2;
    var gocKim = -Math.PI / 2;
    var gocMucDich = gocKim - gocMuc;
    var vongThem = (5 + Math.floor(Math.random() * 4)) * Math.PI * 2;

    var delta = (gocMucDich - (S.goc % (Math.PI * 2))) % (Math.PI * 2);
    if (delta < 0) delta += Math.PI * 2;
    var tongQuay = vongThem + delta;

    var t0 = performance.now();
    var thoiGian = 4500 + Math.random() * 800;
    var gocGoc = S.goc;
    var mocCu = Math.floor((S.goc - gocKim) / cung);

    function buoc(t) {
      var p = Math.min(1, (t - t0) / thoiGian);
      var e = 1 - Math.pow(1 - p, 3.5);
      S.goc = gocGoc + tongQuay * e;

      var mocMoi = Math.floor((S.goc - gocKim) / cung);
      if (mocMoi !== mocCu) {
        amTich();
        mocCu = mocMoi;
      }

      ve();
      if (p < 1) {
        requestAnimationFrame(buoc);
      } else {
        S.dangQuay = false;
        $("nutQuay").disabled = false;
        hienKetQua(chiSo);
      }
    }
    requestAnimationFrame(buoc);
  }

  function hienKetQua(chiSo) {
    var ten = S.muc[chiSo];
    S.trung = chiSo;
    $("ketQua").textContent = ten;
    $("lopPhu").hidden = false;
    amKetQua();

    if ($("loaiTen").checked) {
      S.daQuay.push(ten);
      S.muc.splice(chiSo, 1);
      capNhatOVanBan(S.muc);
      capNhatDaQuay();
      ve();
    }
  }

  function dongKetQua() {
    $("lopPhu").hidden = true;
  }

  function capNhatDaQuay() {
    $("soDaQuay").textContent = S.daQuay.length;
    var ol = $("daQuay");
    ol.innerHTML = "";
    S.daQuay.forEach(function (t) {
      var li = document.createElement("li");
      li.textContent = t;
      ol.appendChild(li);
    });
  }

  function datLai() {
    S.muc = Array.isArray(D.danhSach) ? D.danhSach.slice() : [];
    S.daQuay = [];
    capNhatOVanBan(S.muc);
    capNhatDaQuay();
    ve();
  }

  function capNhatTuO() {
    S.muc = docOVanBan();
    ve();
  }

  /* Gắn sự kiện */
  function khoiTaoSuKien() {
    $("chonLop").addEventListener("change", function () {
      taiGoiLop(this.value);
    });

    $("nutQuay").addEventListener("click", quay);
    $("nutDong").addEventListener("click", dongKetQua);
    $("nutCapNhat").addEventListener("click", capNhatTuO);
    $("nutDatLai").addEventListener("click", datLai);
    $("nutAnBang").addEventListener("click", function () {
      var b = $("bang");
      b.hidden = !b.hidden;
      this.textContent = b.hidden ? "Hiện danh sách" : "Ẩn danh sách";
      doKichThuoc();
    });
    $("nutAm").addEventListener("click", doiAm);
    $("nutToanManHinh").addEventListener("click", batTatToanManHinh);

    window.addEventListener("resize", doKichThuoc);

    // Phím tắt
    document.addEventListener("keydown", function (e) {
      var t = e.target;
      if (t && (t.tagName === "TEXTAREA" || t.tagName === "INPUT")) return;
      if (e.code === "Space") {
        e.preventDefault();
        if (!$("lopPhu").hidden) dongKetQua();
        else quay();
      } else if (e.key === "Enter") {
        if (!$("lopPhu").hidden) { e.preventDefault(); dongKetQua(); }
      } else if (e.key.toLowerCase() === "d") {
        $("nutAnBang").click();
      } else if (e.key.toLowerCase() === "m") {
        doiAm();
      } else if (e.key.toLowerCase() === "f") {
        batTatToanManHinh();
      }
    });
  }

  function khoiDong() {
    khoiTaoSuKien();
    taiGoiLop(maLopHienTai);
    doKichThuoc();
  }

  khoiDong();
})();
