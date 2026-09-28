"""Local Chromium UI checks for the two offline preschool activities."""
import argparse
import json
from pathlib import Path
import tempfile
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait

parser=argparse.ArgumentParser();parser.add_argument('--driver',required=True);args=parser.parse_args()
root=Path(__file__).resolve().parents[1];report=root/'reports/preschool/games';report.mkdir(parents=True,exist_ok=True)
with tempfile.TemporaryDirectory(prefix='preschool-browser-') as tmp:
    options=webdriver.ChromeOptions();options.add_argument('--headless=new');options.add_argument('--window-size=1280,900');options.add_argument('--disable-gpu');options.add_argument('--user-data-dir='+tmp)
    browser=webdriver.Chrome(service=Service(args.driver),options=options)
    try:
        browser.get((root/'preschool/games/mau-sac.html').as_uri())
        buttons=browser.find_elements(By.CSS_SELECTOR,'.colors button');assert len(buttons)==4
        buttons[1].click();assert 'thử lại' in browser.find_element(By.ID,'feedback').text
        buttons[0].click();assert 'Đúng rồi' in browser.find_element(By.ID,'feedback').text
        before=browser.find_element(By.ID,'question').text;browser.find_element(By.ID,'next').click();assert browser.find_element(By.ID,'question').text!=before
        browser.save_screenshot(str(report/'colors.png'))
        browser.get((root/'preschool/games/dong-ho.html').as_uri())
        browser.find_elements(By.CSS_SELECTOR,'#presets button')[0].click();assert browser.find_element(By.ID,'clock').text=='01:00'
        browser.find_element(By.ID,'start').click();assert browser.find_element(By.ID,'start').text=='Tạm dừng'
        browser.find_element(By.ID,'start').click();assert browser.find_element(By.ID,'status').text=='Đã tạm dừng'
        browser.find_element(By.ID,'reset').click();assert browser.find_element(By.ID,'clock').text=='01:00'
        browser.find_element(By.ID,'start').click();browser.execute_script('end=Date.now()-1000;')
        WebDriverWait(browser,3).until(lambda d:'Hết thời gian' in d.find_element(By.ID,'status').text)
        browser.save_screenshot(str(report/'timer.png'))
        (report/'result.json').write_text(json.dumps(dict(colors='passed',timer='passed',browser=browser.capabilities['browserVersion']),indent=2),encoding='utf-8')
        print('PASS: colors correct/retry/next; timer preset/start/pause/reset/completion.')
    finally: browser.quit()
