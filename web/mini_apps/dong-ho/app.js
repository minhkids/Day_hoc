/* Đồng hồ đếm ngược cho hoạt động nhóm - phần mã chạy.
   Cài đặt nằm ở du-lieu.js; thường không cần sửa tệp này. */
(function () {
  "use strict";

  var D = window.DU_LIEU || {};
  var CAC_MOC = Array.isArray(D.cacMoc) && D.cacMoc.length ? D.cacMoc : [1, 3, 5, 10];
  var CANH_BAO = parseInt(D.canhBaoGiay, 10) || 30;
  var CHU_VI = 282.743; // chu vi vòng tròn r = 45 trong hình SVG

  function $(id) { return document.getElementById(id); }

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
      g.gain.exponentialRampToValueAtTime(amLuong || 0.3, t0 + 0.01);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
      o.connect(g); g.connect(amCtx.destination); o.start(t0); o.stop(t0 + thoiGian + 0.05);
    } catch (e) { /* bỏ qua */ }
  }
  function chuong() {
    // ba hồi chuông, mỗi hồi gồm âm chính và hai âm bồi cho giống chuông thật
    [0, 1.1, 2.2].forEach(function (t) {
      beep(880, 1.4, "sine", 0.45, t);
      beep(1320, 1.0, "sine", 0.18, t);
      beep(2640, 0.5, "sine", 0.08, t);
    });
  }
  function tich() { beep(1000, 0.06, "square", 0.1); }

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
  var S = {
    tong: (parseFloat(D.macDinh) || 5) * 60 * 1000, // tổng thời gian đã đặt (mili giây)
    conLai: 0,
    ketThucLuc: 0,   // thời điểm kết thúc (tính theo đồng hồ máy, tránh chạy lệch)
    hen: null,
    giayTruoc: -1,
    daReo: false
  };
  S.conLai = S.tong;

  function dinhDang(ms) {
    var giay = Math.ceil(ms / 1000);
    var p = Math.floor(giay / 60), g = giay % 60;
    return (p < 10 ? "0" : "") + p + ":" + (g < 10 ? "0" : "") + g;
  }

  function ve() {
    var giay = Math.ceil(S.conLai / 1000);
    $("so").textContent = dinhDang(S.conLai);
    var tiLe = S.tong > 0 ? S.conLai / S.tong : 0;
    $("vongChay").style.strokeDashoffset = (CHU_VI * (1 - tiLe)).toFixed(2);
    var dh = $("dongHo");
    var dangChay = !!S.hen;
    dh.classList.toggle("canh-bao", giay <= CANH_BAO && giay > 10);
    dh.classList.toggle("sap-het", giay <= 10 && giay > 0);
    dh.classList.toggle("het-gio", giay <= 0);
    $("trangThai").textContent = giay <= 0 ? "HẾT GIỜ!" : (dangChay ? "Đang chạy" : (S.conLai < S.tong ? "Tạm dừng" : "Sẵn sàng"));
    $("nutChay").textContent = dangChay ? "Tạm dừng" : (giay <= 0 ? "Chạy lại" : (S.conLai < S.tong ? "Chạy tiếp" : "Bắt đầu"));
    document.title = (dangChay ? dinhDang(S.conLai) + " - " : "") + (D.tieuDe || "Đồng hồ");
    var moc = document.querySelectorAll(".nut-moc");
    for (var i = 0; i < moc.length; i++) {
      moc[i].classList.toggle("chon", +moc[i].getAttribute("data-phut") * 60000 === S.tong);
    }
  }

  function buoc() {
    S.conLai = Math.max(0, S.ketThucLuc - Date.now());
    var giay = Math.ceil(S.conLai / 1000);
    if (giay !== S.giayTruoc) {
      if (giay > 0 && giay <= 5) tich();
      S.giayTruoc = giay;
    }
    if (S.conLai <= 0) {
      dung();
      if (!S.daReo) {
        S.daReo = true;
        chuong();
        var man = document.body;
        man.classList.remove("het-gio-nen"); void man.offsetWidth; man.classList.add("het-gio-nen");
      }
    }
    ve();
  }

  function chay() {
    if (S.hen) return;
    if (S.conLai <= 0) { S.conLai = S.tong; S.daReo = false; }
    if (S.conLai <= 0) return;
    beep(1, 0.01, "sine", 0.0002); // mở khóa âm thanh sau cú bấm
    S.ketThucLuc = Date.now() + S.conLai;
    S.hen = setInterval(buoc, 200);
    ve();
  }
  function dung() {
    if (S.hen) { clearInterval(S.hen); S.hen = null; }
  }
  function chayDung() {
    if (S.hen) { buoc(); dung(); ve(); } else chay();
  }
  function datLai() {
    dung();
    S.conLai = S.tong; S.daReo = false; S.giayTruoc = -1;
    document.body.classList.remove("het-gio-nen");
    ve();
  }
  function chonPhut(phut) {
    dung();
    S.tong = phut * 60000;
    datLai();
  }
  function themGiay(giay) {
    var dangChay = !!S.hen;
    if (dangChay) { buoc(); dung(); }
    S.conLai = Math.max(0, Math.min(99 * 60000, S.conLai + giay * 1000));
    if (S.conLai > S.tong) S.tong = S.conLai;
    if (S.conLai > 0) S.daReo = false;
    if (dangChay && S.conLai > 0) chay();
    ve();
  }
  function doiAm() {
    tatTieng = !tatTieng;
    $("nutAm").textContent = tatTieng ? "Chuông: Tắt" : "Chuông: Bật";
  }

  /* ---------- Phím tắt ---------- */
  document.addEventListener("keydown", function (e) {
    if (e.ctrlKey || e.altKey || e.metaKey) return;
    var t = e.target;
    if (t && t.tagName === "INPUT") {
      if (e.key === "Enter" || e.key === "Escape") t.blur();
      return;
    }
    var k = e.key.length === 1 ? e.key.toLowerCase() : e.key;
    if (k === " " || k === "Enter") { e.preventDefault(); chayDung(); }
    else if (k === "r") datLai();
    else if (k === "1") chonPhut(CAC_MOC[0] || 1);
    else if (k === "3") chonPhut(CAC_MOC[1] || 3);
    else if (k === "5") chonPhut(CAC_MOC[2] || 5);
    else if (k === "0") chonPhut(CAC_MOC[3] || 10);
    else if (k === "+" || k === "=" || k === "ArrowUp") { e.preventDefault(); themGiay(30); }
    else if (k === "-" || k === "_" || k === "ArrowDown") { e.preventDefault(); themGiay(-30); }
    else if (k === "f") batTatToanManHinh();
    else if (k === "m") doiAm();
  });
  document.addEventListener("click", function (e) {
    var b = e.target.closest ? e.target.closest("button") : null;
    if (b) b.blur();
  });

  /* ---------- Khởi động ---------- */
  $("tieuDe").textContent = D.tieuDe || "Đồng hồ hoạt động nhóm";
  $("tenHoatDong").value = D.hoatDong || "";
  (D.cacHoatDong || []).forEach(function (ten) {
    var o = document.createElement("option"); o.value = ten; $("goiYHoatDong").appendChild(o);
  });
  CAC_MOC.forEach(function (phut) {
    var b = document.createElement("button");
    b.type = "button"; b.className = "nut nut-moc";
    b.setAttribute("data-phut", phut);
    b.textContent = phut + " phút";
    b.addEventListener("click", function () { chonPhut(phut); });
    $("cacMoc").appendChild(b);
  });
  $("nutChay").addEventListener("click", chayDung);
  $("nutDatLai").addEventListener("click", datLai);
  $("nutThem").addEventListener("click", function () { themGiay(30); });
  $("nutBot").addEventListener("click", function () { themGiay(-30); });
  $("nutAm").addEventListener("click", doiAm);
  $("nutToanManHinh").addEventListener("click", batTatToanManHinh);
  ve();
})();
