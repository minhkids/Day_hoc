/**
 * HỆ THỐNG TRỢ LÝ AI GIÁO DỤC - INTERACTIVE LOGIC
 */

document.addEventListener('DOMContentLoaded', () => {
  initNavigation();
  initFAQ();
  initSearch();
  initInteractiveDemo();
  initLuckyWheel();
});

/* ==========================================================================
   NAVIGATION & ACTIVE STATES
   ========================================================================== */
function initNavigation() {
  const sections = document.querySelectorAll('section[id]');
  const navLinks = document.querySelectorAll('.nav-link');
  const mobileToggle = document.getElementById('mobileToggle');
  const navMenu = document.querySelector('.nav-links');

  // Mobile menu toggle
  if (mobileToggle && navMenu) {
    mobileToggle.addEventListener('click', () => {
      const isOpen = navMenu.style.display === 'flex';
      navMenu.style.display = isOpen ? 'none' : 'flex';
      navMenu.style.flexDirection = 'column';
      navMenu.style.position = 'absolute';
      navMenu.style.top = '72px';
      navMenu.style.left = '0';
      navMenu.style.width = '100%';
      navMenu.style.background = '#FFFFFF';
      navMenu.style.padding = '20px';
      navMenu.style.borderBottom = '1px solid var(--line)';
      navMenu.style.boxShadow = 'var(--shadow-md)';
    });
  }

  // Scroll spy for active navigation item
  window.addEventListener('scroll', () => {
    const scrollY = window.pageYOffset;
    sections.forEach(current => {
      const sectionHeight = current.offsetHeight;
      const sectionTop = current.offsetTop - 120;
      const sectionId = current.getAttribute('id');

      if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
        navLinks.forEach(link => {
          link.classList.remove('active');
          if (link.getAttribute('href') === `#${sectionId}`) {
            link.classList.add('active');
          }
        });
      }
    });
  });
}

/* ==========================================================================
   FAQ ACCORDION
   ========================================================================== */
function initFAQ() {
  const faqItems = document.querySelectorAll('.faq-item');
  faqItems.forEach(item => {
    const questionBtn = item.querySelector('.faq-question');
    questionBtn.addEventListener('click', () => {
      const isActive = item.classList.contains('active');
      faqItems.forEach(i => i.classList.remove('active'));
      if (!isActive) {
        item.classList.add('active');
      }
    });
  });
}

/* ==========================================================================
   LIVE SEARCH FILTERING
   ========================================================================== */
function initSearch() {
  const searchInput = document.getElementById('mainSearchInput');
  if (!searchInput) return;

  searchInput.addEventListener('input', (e) => {
    const query = e.target.value.toLowerCase().trim();
    if (!query) {
      document.querySelectorAll('.assistant-card, .faq-item, .office-card').forEach(el => el.style.display = '');
      return;
    }

    // Filter assistant cards
    document.querySelectorAll('.assistant-card').forEach(card => {
      const text = card.textContent.toLowerCase();
      card.style.display = text.includes(query) ? '' : 'none';
    });

    // Filter FAQ items
    document.querySelectorAll('.faq-item').forEach(item => {
      const text = item.textContent.toLowerCase();
      item.style.display = text.includes(query) ? '' : 'none';
      if (text.includes(query)) item.classList.add('active');
    });
  });
}

/* ==========================================================================
   INTERACTIVE LIVE PLAYGROUND / DEMO TABS
   ========================================================================== */
function initInteractiveDemo() {
  const tabBtns = document.querySelectorAll('.demo-tab-btn');
  const tabContents = document.querySelectorAll('.demo-tab-content');

  tabBtns.forEach(btn => {
    btn.addEventListener('click', () => {
      const targetTab = btn.getAttribute('data-tab');
      tabBtns.forEach(b => b.classList.remove('active'));
      tabContents.forEach(c => c.classList.remove('active'));

      btn.classList.add('active');
      const activeContent = document.getElementById(`tab-${targetTab}`);
      if (activeContent) activeContent.classList.add('active');
    });
  });

  // Demo 1: Soạn văn bản Nghị định 30
  const btnGenDoc = document.getElementById('btnGenerateDoc');
  if (btnGenDoc) {
    btnGenDoc.addEventListener('click', () => {
      const schoolName = document.getElementById('docSchoolName').value || 'TRƯỜNG TIỂU HỌC QUẢNG CHÂU 1';
      const docType = document.getElementById('docType').value || 'QUYẾT ĐỊNH';
      const docContent = document.getElementById('docSummary').value || 'Về việc thành lập Hội đồng tự đánh giá kiểm định chất lượng giáo dục năm học 2026 - 2027';

      const previewArea = document.getElementById('docPreviewArea');
      previewArea.innerHTML = `
        <table class="doc-header-table">
          <tr>
            <td style="width: 45%;">
              UBND HUYỆN QUẢNG TRẠCH<br>
              <strong>${schoolName.toUpperCase()}</strong><br>
              Số: 88/QĐ-THQC
              <div style="width: 80px; height: 1px; background: #000; margin: 4px auto;"></div>
            </td>
            <td style="width: 55%;">
              <strong>CỘNG HÒA XÃ HỘI CHỦ NGHĨA VIỆT NAM</strong><br>
              <strong>Độc lập - Tự do - Hạnh phúc</strong><br>
              <div style="width: 140px; height: 1px; background: #000; margin: 4px auto;"></div>
              <em>Quảng Châu, ngày 20 tháng 9 năm 2026</em>
            </td>
          </tr>
        </table>

        <div class="doc-title">
          ${docType}<br>
          <span style="font-size: 14px; text-transform: none; font-weight: normal;">${docContent}</span>
        </div>

        <p style="text-align: center; font-weight: bold; margin-bottom: 12px;">HIỆU TRƯỞNG TRƯỜNG TIỂU HỌC</p>
        
        <p style="text-indent: 30px; margin-bottom: 8px;"><em>Căn cứ Điều lệ trường Tiểu học ban hành kèm theo Thông tư số 28/2020/TT-BGDĐT ngày 04/9/2020 của Bộ trưởng Bộ Giáo dục và Đào tạo;</em></p>
        <p style="text-indent: 30px; margin-bottom: 8px;"><em>Căn cứ Thông tư số 17/2018/TT-BGDĐT ngày 22/8/2018 của Bộ GD&ĐT quy định về kiểm định chất lượng giáo dục và công nhận đạt chuẩn quốc gia đối với trường tiểu học;</em></p>
        <p style="text-indent: 30px; margin-bottom: 14px;"><em>Xét đề nghị của Tổ trưởng chuyên môn và Hội đồng thi đua nhà trường,</em></p>

        <p style="text-align: center; font-weight: bold; margin-bottom: 12px;">QUYẾT ĐỊNH:</p>
        <p style="text-indent: 30px; margin-bottom: 8px;"><strong>Điều 1.</strong> Thành lập Hội đồng tự đánh giá kiểm định chất lượng giáo dục Trường Tiểu học năm học 2026 - 2027 gồm các ông (bà) có tên trong danh sách kèm theo.</p>
        <p style="text-indent: 30px; margin-bottom: 8px;"><strong>Điều 2.</strong> Hội đồng có nhiệm vụ xây dựng kế hoạch tự đánh giá, thu thập minh chứng, viết báo cáo tự đánh giá theo đúng quy định hiện hành của Bộ GD&ĐT.</p>
        <p style="text-indent: 30px; margin-bottom: 24px;"><strong>Điều 3.</strong> Các bộ phận liên quan và các cá nhân có tên tại Điều 1 chịu trách nhiệm thi hành Quyết định này./.</p>

        <table style="width: 100%; margin-top: 20px;">
          <tr>
            <td style="width: 50%; font-size: 12px;">
              <strong><em>Nơi nhận:</em></strong><br>
              - Phòng GD&ĐT (để b/c);<br>
              - Như Điều 3 (để t/h);<br>
              - Lưu: VT, HĐTĐ.
            </td>
            <td style="width: 50%; text-align: center;">
              <strong>HIỆU TRƯỞNG</strong><br>
              <em>(Ký, đóng dấu)</em><br><br><br>
              <strong>Nguyễn Văn An</strong>
            </td>
          </tr>
        </table>
      `;

      showToast('Đã sinh văn bản chuẩn Nghị định 30/2020/NĐ-CP thành công!');
    });
  }

  // Demo 2: Soạn giáo án Công văn 5512
  const btnGenLesson = document.getElementById('btnGenerateLesson');
  if (btnGenLesson) {
    btnGenLesson.addEventListener('click', () => {
      const subject = document.getElementById('lessonSubject').value || 'Toán học';
      const grade = document.getElementById('lessonGrade').value || 'Lớp 4';
      const topic = document.getElementById('lessonTopic').value || 'Góc nhọn, góc tù, góc bẹt';

      const previewArea = document.getElementById('lessonPreviewArea');
      previewArea.innerHTML = `
        <div style="text-align: center; margin-bottom: 16px;">
          <h4 style="font-size: 16px; text-transform: uppercase;">KẾ HOẠCH BÀI DẠY (THEO CÔNG VĂN 5512/BGDĐT)</h4>
          <p><strong>Môn:</strong> ${subject} - <strong>Cấp:</strong> ${grade}</p>
          <p><strong>Tên bài:</strong> <span style="color: var(--blue-primary);">${topic}</span> (Thời lượng: 1 tiết)</p>
        </div>

        <div style="background: #FFF; padding: 14px; border: 1px solid var(--line); border-radius: 8px; margin-bottom: 12px;">
          <strong style="color: var(--navy);">I. YÊU CẦU CẦN ĐẠT:</strong>
          <ul style="padding-left: 20px; margin-top: 6px;">
            <li><strong>1. Năng lực đặc thù:</strong> Nhận biết được góc nhọn, góc tù, góc bẹt. Sử dụng thước ê-ke để kiểm tra và vẽ được các góc đã học.</li>
            <li><strong>2. Năng lực chung:</strong> Tự chủ tự học, giao tiếp hợp tác qua thảo luận nhóm để giải quyết vấn đề nhận diện góc thực tế.</li>
            <li><strong>3. Phẩm chất:</strong> Chăm chỉ quan sát các đồ vật trong lớp, trung thực trong thực hiện bài tập.</li>
          </ul>
        </div>

        <div style="background: #FFF; padding: 14px; border: 1px solid var(--line); border-radius: 8px; margin-bottom: 12px;">
          <strong style="color: var(--navy);">II. TIẾN TRÌNH DẠY HỌC (4 HOẠT ĐỘNG CHUẨN):</strong>
          <ol style="padding-left: 20px; margin-top: 6px; display: grid; gap: 8px;">
            <li><strong>1. Hoạt động Khởi động (5 phút):</strong> Trò chơi "Đố bạn tìm góc" thông qua hình ảnh kim đồng hồ chỉ 2 giờ, 6 giờ, 9 giờ.</li>
            <li><strong>2. Hoạt động Hình thành kiến thức (15 phút):</strong> Hướng dẫn học sinh dùng ê-ke so sánh độ mở của các góc với góc vuông để rút ra khái niệm góc nhọn (< góc vuông), góc tù (> góc vuông), góc bẹt (= 2 góc vuông).</li>
            <li><strong>3. Hoạt động Luyện tập (12 phút):</strong> Thực hành bài tập 1, 2 trong SGK - kiểm tra các góc trong hình vẽ tam giác và tứ giác.</li>
            <li><strong>4. Hoạt động Vận dụng (3 phút):</strong> Tìm kiếm các góc thực tế trong phòng học (góc bàn, mép bảng, góc mở cửa sổ).</li>
          </ol>
        </div>
      `;

      showToast('Đã tạo kế hoạch bài dạy chuẩn CV 5512!');
    });
  }
}

/* ==========================================================================
   LUCKY WHEEL CANVAS (XƯỞNG PHẦN MỀM DEMO)
   ========================================================================== */
function initLuckyWheel() {
  const canvas = document.getElementById('wheelCanvas');
  const btnSpin = document.getElementById('btnSpinWheel');
  const studentNamesInput = document.getElementById('wheelStudents');
  const winnerDisplay = document.getElementById('wheelWinner');

  if (!canvas || !btnSpin) return;
  const ctx = canvas.getContext('2d');

  let students = ['Nguyễn An', 'Trần Bình', 'Lê Cúc', 'Phạm Dũng', 'Hoàng Yến', 'Đỗ Giang', 'Bùi Hà', 'Vũ Khoa'];
  const colors = ['#1462E6', '#0E9AA7', '#7B5CF0', '#F08A24', '#1FA971', '#D24726', '#3D4A66', '#0B4FC4'];

  let startAngle = 0;
  let arc = Math.PI / (students.length / 2);
  let spinTime = 0;
  let spinTimeTotal = 0;
  let spinAngleStart = 0;

  function drawWheel() {
    if (studentNamesInput && studentNamesInput.value.trim()) {
      students = studentNamesInput.value.split(',').map(s => s.trim()).filter(Boolean);
      if (students.length === 0) students = ['Học sinh 1', 'Học sinh 2'];
    }
    arc = Math.PI / (students.length / 2);

    ctx.clearRect(0, 0, canvas.width, canvas.height);
    const outsideRadius = 140;
    const textRadius = 100;
    const insideRadius = 20;

    for (let i = 0; i < students.length; i++) {
      const angle = startAngle + i * arc;
      ctx.fillStyle = colors[i % colors.length];

      ctx.beginPath();
      ctx.arc(150, 150, outsideRadius, angle, angle + arc, false);
      ctx.arc(150, 150, insideRadius, angle + arc, angle, true);
      ctx.fill();
      ctx.stroke();

      ctx.save();
      ctx.fillStyle = '#FFFFFF';
      ctx.font = 'bold 12px "Be Vietnam Pro", sans-serif';
      ctx.translate(150 + Math.cos(angle + arc / 2) * textRadius, 
                    150 + Math.sin(angle + arc / 2) * textRadius);
      ctx.rotate(angle + arc / 2 + Math.PI / 2);
      const text = students[i];
      ctx.fillText(text, -ctx.measureText(text).width / 2, 0);
      ctx.restore();
    }
  }

  function rotateWheel() {
    spinTime += 30;
    if (spinTime >= spinTimeTotal) {
      stopRotateWheel();
      return;
    }
    const spinAngle = spinAngleStart - easeOut(spinTime, 0, spinAngleStart, spinTimeTotal);
    startAngle += (spinAngle * Math.PI / 180);
    drawWheel();
    requestAnimationFrame(rotateWheel);
  }

  function stopRotateWheel() {
    const degrees = startAngle * 180 / Math.PI + 90;
    const arcd = arc * 180 / Math.PI;
    const index = Math.floor((360 - degrees % 360) / arcd) % students.length;
    const winner = students[index];
    if (winnerDisplay) {
      winnerDisplay.innerHTML = `🎉 Chúc mừng bạn: <strong>${winner}</strong> lên bảng trả lời!`;
    }
    showToast(`🎉 Đã chọn: ${winner}`);
    btnSpin.disabled = false;
  }

  function easeOut(t, b, c, d) {
    const ts = (t /= d) * t;
    const tc = ts * t;
    return b + c * (tc + -3 * ts + 3 * t);
  }

  btnSpin.addEventListener('click', () => {
    btnSpin.disabled = true;
    if (winnerDisplay) winnerDisplay.textContent = 'Đang quay vòng quay...';
    spinAngleStart = Math.random() * 10 + 20;
    spinTime = 0;
    spinTimeTotal = Math.random() * 3 + 4 * 1000;
    rotateWheel();
  });

  if (studentNamesInput) {
    studentNamesInput.addEventListener('input', drawWheel);
  }

  drawWheel();
}

/* ==========================================================================
   TOAST NOTIFICATION HELPER
   ========================================================================== */
function showToast(message) {
  let toast = document.getElementById('siteToast');
  if (!toast) {
    toast = document.createElement('div');
    toast.id = 'siteToast';
    toast.className = 'toast-box';
    document.body.appendChild(toast);
  }

  toast.innerHTML = `
    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#1FA971" stroke-width="2.5">
      <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"/>
      <polyline points="22 4 12 14.01 9 11.01"/>
    </svg>
    <span>${message}</span>
  `;

  toast.classList.add('show');
  setTimeout(() => {
    toast.classList.remove('show');
  }, 3500);
}
