/* Khung trống - phần mã chạy. Có sẵn các công cụ hay dùng:
   toàn màn hình, âm thanh, xáo trộn, lưu tạm an toàn, phím tắt.
   Nội dung nằm ở du-lieu.js. */
(function () {
  "use strict";

  var D = window.DU_LIEU || {};

  function $(id) { return document.getElementById(id); }

  /* ---------- Công cụ dùng chung ---------- */

  // Toàn màn hình (bấm lại để thoát)
  function batTatToanManHinh() {
    var d = document, el = d.documentElement, p;
    try {
      if (!d.fullscreenElement && !d.webkitFullscreenElement) p = (el.requestFullscreen || el.webkitRequestFullscreen).call(el);
      else p = (d.exitFullscreen || d.webkitExitFullscreen).call(d);
      if (p && p.catch) p.catch(function () {});
    } catch (e) { /* bỏ qua */ }
  }

  // Âm thanh "bíp" bằng Web Audio - không cần tệp âm thanh
  var amCtx = null;
  function beep(tanSo, thoiGian, kieu, amLuong, treo) {
    try {
      if (!amCtx) { var AC = window.AudioContext || window.webkitAudioContext; if (!AC) return; amCtx = new AC(); }
      if (amCtx.state === "suspended") amCtx.resume();
      var t0 = amCtx.currentTime + (treo || 0), o = amCtx.createOscillator(), g = amCtx.createGain();
      o.type = kieu || "sine"; o.frequency.value = tanSo;
      g.gain.setValueAtTime(0.0001, t0);
      g.gain.exponentialRampToValueAtTime(amLuong || 0.3, t0 + 0.02);
      g.gain.exponentialRampToValueAtTime(0.0001, t0 + thoiGian);
      o.connect(g); g.connect(amCtx.destination); o.start(t0); o.stop(t0 + thoiGian + 0.05);
    } catch (e) { /* máy không hỗ trợ âm thanh */ }
  }
  var AM = {
    dung: function () { beep(660, 0.15, "sine", 0.35); beep(880, 0.15, "sine", 0.35, 0.12); beep(1320, 0.35, "sine", 0.35, 0.24); },
    sai: function () { beep(220, 0.35, "sawtooth", 0.2); beep(170, 0.45, "sawtooth", 0.2, 0.18); }
  };

  // Xáo trộn mảng (Fisher-Yates)
  function xaoTron(mang) {
    for (var i = mang.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var t = mang[i]; mang[i] = mang[j]; mang[j] = t;
    }
    return mang;
  }

  // Lưu tạm trên máy này (không bao giờ làm hỏng phần mềm nếu trình duyệt chặn)
  var KHOA_LUU = "trong:" + (D.tieuDe || "phan-mem");
  function docTam(macDinh) {
    try { var s = localStorage.getItem(KHOA_LUU); return s ? JSON.parse(s) : macDinh; } catch (e) { return macDinh; }
  }
  function luuTam(giaTri) {
    try { localStorage.setItem(KHOA_LUU, JSON.stringify(giaTri)); } catch (e) { /* bỏ qua */ }
  }

  /* ---------- Phần riêng của phần mềm ---------- */
  var soLanBam = docTam({ soLan: 0 }).soLan || 0;

  function veNoiDung() {
    document.title = D.tieuDe || document.title;
    $("tieuDe").textContent = D.tieuDe || "Phần mềm dạy học";
    $("monLop").textContent = D.monLop || "";
    $("loiGioiThieu").textContent = D.loiGioiThieu || "";
    var hop = $("cacMuc");
    hop.innerHTML = "";
    (D.cacMuc || []).forEach(function (m) {
      var the = document.createElement("article");
      the.className = "the";
      var h = document.createElement("h3"); h.textContent = m.tieuDe || "";
      var p = document.createElement("p"); p.textContent = m.noiDung || "";
      the.appendChild(h); the.appendChild(p);
      hop.appendChild(the);
    });
  }

  function bamThu() {
    soLanBam++;
    luuTam({ soLan: soLanBam });
    AM.dung();
    var tb = $("thongBao");
    tb.textContent = "Phần mềm chạy tốt! (đã bấm " + soLanBam + " lần trên máy này)";
    tb.className = "thong-bao dung";
    tb.classList.remove("nhay"); void tb.offsetWidth; tb.classList.add("nhay");
  }

  /* ---------- Phím tắt ---------- */
  document.addEventListener("keydown", function (e) {
    if (e.ctrlKey || e.altKey || e.metaKey) return;
    var t = e.target;
    if (t && /^(INPUT|SELECT|TEXTAREA)$/.test(t.tagName)) return; // đang gõ chữ thì bỏ qua phím tắt
    var k = e.key.length === 1 ? e.key.toLowerCase() : e.key;
    if (k === " ") { e.preventDefault(); bamThu(); }
    else if (k === "f") batTatToanManHinh();
  });
  // Bỏ tiêu điểm khỏi nút sau khi bấm chuột để phím Space không bấm lại nút đó
  document.addEventListener("click", function (e) {
    var b = e.target.closest ? e.target.closest("button") : null;
    if (b) b.blur();
  });

  /* ---------- Khởi động ---------- */
  $("nutToanManHinh").addEventListener("click", batTatToanManHinh);
  $("nutThu").addEventListener("click", bamThu);
  veNoiDung();
  void xaoTron; void AM.sai; // có sẵn để dùng khi cần
})();
