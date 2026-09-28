"""Ward merger dictionary and address converter for Vietnamese administrative restructuring.

Handles converting residential addresses between pre-merger (trước sáp nhập)
and post-merger (sau sáp nhập) ward/commune administrative units.
Integrates the official GeoVina API (https://geovina.io.vn/docs) for automatic
two-way address parsing and restructuring, with automatic fallback to local rules when offline.
Also provides preschool child growth/nutrition evaluation utilities.
"""
from __future__ import annotations
import json
import os
from pathlib import Path
import re
import threading
import time
from typing import Any, Dict, List, Optional, Tuple
import unicodedata
import urllib.error
import urllib.parse
import urllib.request

# GeoVina API endpoints (https://geovina.io.vn/docs)
GEOVINA_BASE_URL = "https://geovina.io.vn"
GEOVINA_PARSE_ENDPOINT = f"{GEOVINA_BASE_URL}/parse"
GEOVINA_BATCH_ENDPOINT = f"{GEOVINA_BASE_URL}/batch"
GEOVINA_TOKEN_ENDPOINT = f"{GEOVINA_BASE_URL}/api?action=demo-token"

_demo_token: Optional[str] = None
_demo_token_time: float = 0.0
_demo_token_lock = threading.Lock()
DEMO_TOKEN_TTL = 900.0  # 15 minutes

# Built-in administrative merger rules for major provinces/cities according to
# the National Assembly Standing Committee Resolutions on ward/commune restructuring.
DEFAULT_WARD_MERGERS: List[Dict[str, str]] = [
    # Hà Nội - Đống Đa
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Phương Liên",
        "new_ward": "Phường Kim Liên",
        "note": "Sáp nhập vào Phường Kim Liên"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Trung Tự",
        "new_ward": "Phường Kim Liên",
        "note": "Sáp nhập vào Phường Kim Liên"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Khâm Thiên",
        "new_ward": "Phường Khâm Thiên",
        "note": "Sáp nhập Phường Trung Phụng vào Phường Khâm Thiên"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Trung Phụng",
        "new_ward": "Phường Khâm Thiên",
        "note": "Sáp nhập vào Phường Khâm Thiên"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Quốc Tử Giám",
        "new_ward": "Phường Văn Miếu - Quốc Tử Giám",
        "note": "Sáp nhập thành Phường Văn Miếu - Quốc Tử Giám"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Đống Đa",
        "old_ward": "Phường Văn Miếu",
        "new_ward": "Phường Văn Miếu - Quốc Tử Giám",
        "note": "Sáp nhập thành Phường Văn Miếu - Quốc Tử Giám"
    },
    # Hà Nội - Long Biên
    {
        "province": "Hà Nội",
        "district": "Quận Long Biên",
        "old_ward": "Phường Ngọc Thụy",
        "new_ward": "Phường Hồng Hà",
        "note": "Sáp nhập thành Phường Hồng Hà"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Long Biên",
        "old_ward": "Phường Bồ Đề",
        "new_ward": "Phường Bồ Đề",
        "note": "Sắp xếp đơn vị hành chính Quận Long Biên"
    },
    # Hà Nội - Ba Đình
    {
        "province": "Hà Nội",
        "district": "Quận Ba Đình",
        "old_ward": "Phường Nguyễn Trung Trực",
        "new_ward": "Phường Trúc Bạch",
        "note": "Sáp nhập vào Phường Trúc Bạch"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Ba Đình",
        "old_ward": "Phường Trúc Bạch",
        "new_ward": "Phường Ba Đình",
        "note": "Sáp nhập vào Phường Ba Đình (mô hình sau sáp nhập)"
    },
    # Hà Nội - Hoàn Kiếm
    {
        "province": "Hà Nội",
        "district": "Quận Hoàn Kiếm",
        "old_ward": "Phường Hàng Bạc",
        "new_ward": "Phường Hàng Đào",
        "note": "Sáp nhập vào Phường Hàng Đào"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Hoàn Kiếm",
        "old_ward": "Phường Hàng Buồm",
        "new_ward": "Phường Hàng Gai",
        "note": "Sáp nhập vào Phường Hàng Gai"
    },
    # Hà Nội - Hai Bà Trưng
    {
        "province": "Hà Nội",
        "district": "Quận Hai Bà Trưng",
        "old_ward": "Phường Đống Mác",
        "new_ward": "Phường Đồng Nhân",
        "note": "Sáp nhập vào Phường Đồng Nhân"
    },
    {
        "province": "Hà Nội",
        "district": "Quận Hai Bà Trưng",
        "old_ward": "Phường Cầu Dền",
        "new_ward": "Phường Bách Khoa",
        "note": "Sáp nhập vào Phường Bách Khoa và Phường Thanh Nhàn"
    },
    # TP. Hồ Chí Minh - Quận 3
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 3",
        "old_ward": "Phường 5",
        "new_ward": "Phường Bàn Cờ",
        "note": "Sáp nhập vào Phường Bàn Cờ"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 3",
        "old_ward": "Phường 10",
        "new_ward": "Phường 9",
        "note": "Sáp nhập Phường 10 vào Phường 9"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 3",
        "old_ward": "Phường 12",
        "new_ward": "Phường 11",
        "note": "Sáp nhập Phường 12 vào Phường 11"
    },
    # TP. Hồ Chí Minh - Quận 4
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 4",
        "old_ward": "Phường 6",
        "new_ward": "Phường 9",
        "note": "Sáp nhập Phường 6 vào Phường 9"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 4",
        "old_ward": "Phường 10",
        "new_ward": "Phường 8",
        "note": "Sáp nhập Phường 10 vào Phường 8"
    },
    # TP. Hồ Chí Minh - Quận 5
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 5",
        "old_ward": "Phường 3",
        "new_ward": "Phường 2",
        "note": "Sáp nhập Phường 3 vào Phường 2"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 5",
        "old_ward": "Phường 6",
        "new_ward": "Phường 5",
        "note": "Sáp nhập Phường 6 vào Phường 5"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận 5",
        "old_ward": "Phường 8",
        "new_ward": "Phường 7",
        "note": "Sáp nhập Phường 8 vào Phường 7"
    },
    # TP. Hồ Chí Minh - Quận Phú Nhuận
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận Phú Nhuận",
        "old_ward": "Phường 12",
        "new_ward": "Phường 11",
        "note": "Sáp nhập Phường 12 vào Phường 11"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận Phú Nhuận",
        "old_ward": "Phường 14",
        "new_ward": "Phường 13",
        "note": "Sáp nhập Phường 14 vào Phường 13"
    },
    # TP. Hồ Chí Minh - Quận Bình Thạnh
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận Bình Thạnh",
        "old_ward": "Phường 3",
        "new_ward": "Phường 1",
        "note": "Sáp nhập Phường 3 vào Phường 1"
    },
    # TP. Hồ Chí Minh - Quận Gò Vấp
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận Gò Vấp",
        "old_ward": "Phường 9",
        "new_ward": "Phường 8",
        "note": "Sáp nhập Phường 9 vào Phường 8"
    },
    {
        "province": "TP. Hồ Chí Minh",
        "district": "Quận Gò Vấp",
        "old_ward": "Phường 15",
        "new_ward": "Phường 14",
        "note": "Sáp nhập Phường 15 vào Phường 14"
    },
    # Đà Nẵng - Quận Hải Châu
    {
        "province": "Đà Nẵng",
        "district": "Quận Hải Châu",
        "old_ward": "Phường Hải Châu 2",
        "new_ward": "Phường Hải Châu 1",
        "note": "Sáp nhập Hải Châu 2 vào Hải Châu 1"
    },
    {
        "province": "Đà Nẵng",
        "district": "Quận Hải Châu",
        "old_ward": "Phường Phước Ninh",
        "new_ward": "Phường Nam Dương",
        "note": "Sáp nhập Phước Ninh vào Nam Dương"
    },
    # Hải Phòng - Quận Hồng Bàng
    {
        "province": "Hải Phòng",
        "district": "Quận Hồng Bàng",
        "old_ward": "Phường Trại Chuối",
        "new_ward": "Phường Thượng Lý",
        "note": "Sáp nhập vào Phường Thượng Lý"
    },
    {
        "province": "Hải Phòng",
        "district": "Quận Hồng Bàng",
        "old_ward": "Phường Hạ Lý",
        "new_ward": "Phường Hoàng Văn Thụ",
        "note": "Sáp nhập vào Phường Hoàng Văn Thụ"
    }
]


def normalize_nfc(val: Any) -> Any:
    """Normalize strings to Unicode NFC form for clean Vietnamese display."""
    if isinstance(val, str):
        return unicodedata.normalize("NFC", val)
    if isinstance(val, dict):
        return {k: normalize_nfc(v) for k, v in val.items()}
    if isinstance(val, list):
        return [normalize_nfc(x) for x in val]
    return val


def get_rules_file(root_dir: Path | str) -> Path:
    return Path(root_dir) / "quy-tac-sap-nhap.json"


def get_cache_file(root_dir: Path | str) -> Path:
    return Path(root_dir) / "geovina_cache.json"


def _get_from_cache(root_dir: Optional[Path | str], address: str) -> Optional[Dict[str, Any]]:
    if not root_dir:
        return None
    cache_path = get_cache_file(root_dir)
    if not cache_path.is_file():
        return None
    try:
        data = json.loads(cache_path.read_text(encoding="utf-8"))
        key = address.strip().lower()
        if key in data:
            return data[key]
    except Exception:
        pass
    return None


def _save_to_cache(root_dir: Optional[Path | str], address: str, item_data: Dict[str, Any]) -> None:
    if not root_dir or not address:
        return
    cache_path = get_cache_file(root_dir)
    cache: Dict[str, Any] = {}
    if cache_path.is_file():
        try:
            cache = json.loads(cache_path.read_text(encoding="utf-8"))
            if not isinstance(cache, dict):
                cache = {}
        except Exception:
            cache = {}

    key = address.strip().lower()
    cache[key] = item_data
    # Limit cache size to 500 entries
    if len(cache) > 500:
        keys_to_remove = list(cache.keys())[:100]
        for k in keys_to_remove:
            cache.pop(k, None)

    try:
        temp = cache_path.with_suffix(".tmp")
        temp.write_text(json.dumps(cache, ensure_ascii=False, indent=2), encoding="utf-8")
        temp.replace(cache_path)
    except Exception:
        pass


def get_geovina_demo_token(timeout: float = 5.0) -> Optional[str]:
    """
    Fetch and cache a temporary demo token from GeoVina API.
    The demo token provides free conversion quota (10 req/min for parse, 5 req/5min for batch).
    """
    global _demo_token, _demo_token_time
    now = time.time()
    with _demo_token_lock:
        if _demo_token and (now - _demo_token_time) < DEMO_TOKEN_TTL:
            return _demo_token
        try:
            req = urllib.request.Request(
                GEOVINA_TOKEN_ENDPOINT,
                data=b"",
                headers={
                    "Content-Type": "application/json",
                    "User-Agent": "TroLyGiaoVienMamNon/1.0"
                },
                method="POST"
            )
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                if resp.status == 200:
                    payload = json.loads(resp.read().decode("utf-8"))
                    token = payload.get("token")
                    if token:
                        _demo_token = token
                        _demo_token_time = now
                        return token
        except Exception:
            pass
        return _demo_token


def call_geovina_parse(
    address: str,
    root_dir: Optional[Path | str] = None,
    api_key: Optional[str] = None,
    timeout: float = 6.0
) -> Optional[Dict[str, Any]]:
    """
    Call GeoVina API (/parse) to convert an address.
    Checks local cache first. Falls back automatically if offline.
    """
    addr_clean = (address or "").strip()
    if not addr_clean:
        return None

    # Check cache first
    cached = _get_from_cache(root_dir, addr_clean)
    if cached:
        return cached

    headers: Dict[str, str] = {
        "Content-Type": "application/json",
        "User-Agent": "TroLyGiaoVienMamNon/1.0"
    }

    if api_key and str(api_key).strip():
        headers["X-Api-Key"] = str(api_key).strip()
    else:
        token = get_geovina_demo_token(timeout=timeout)
        if token:
            headers["X-Demo-Token"] = token
        else:
            return None

    data_bytes = json.dumps({"address": addr_clean}).encode("utf-8")
    req = urllib.request.Request(
        GEOVINA_PARSE_ENDPOINT,
        data=data_bytes,
        headers=headers,
        method="POST"
    )

    try:
        with urllib.request.urlopen(req, timeout=timeout) as resp:
            if resp.status == 200:
                raw_json = json.loads(resp.read().decode("utf-8"))
                if raw_json.get("success") and raw_json.get("data"):
                    norm_data = normalize_nfc(raw_json["data"])
                    _save_to_cache(root_dir, addr_clean, norm_data)
                    return norm_data
    except Exception:
        pass
    return None


def call_geovina_batch(
    addresses: List[str],
    root_dir: Optional[Path | str] = None,
    api_key: Optional[str] = None,
    timeout: float = 12.0
) -> Optional[List[Dict[str, Any]]]:
    """
    Call GeoVina API (/batch) for batch converting up to 50 addresses at once.
    """
    clean_list = [str(a).strip() for a in addresses if str(a).strip()]
    if not clean_list:
        return []

    headers: Dict[str, str] = {
        "Content-Type": "application/json",
        "User-Agent": "TroLyGiaoVienMamNon/1.0"
    }
    if api_key and str(api_key).strip():
        headers["X-Api-Key"] = str(api_key).strip()
    else:
        token = get_geovina_demo_token(timeout=timeout)
        if token:
            headers["X-Demo-Token"] = token
        else:
            return None

    results: List[Dict[str, Any]] = []
    # GeoVina supports up to 50 addresses per batch request
    for i in range(0, len(clean_list), 50):
        chunk = clean_list[i:i + 50]
        data_bytes = json.dumps({"addresses": chunk}).encode("utf-8")
        req = urllib.request.Request(
            GEOVINA_BATCH_ENDPOINT,
            data=data_bytes,
            headers=headers,
            method="POST"
        )
        try:
            with urllib.request.urlopen(req, timeout=timeout) as resp:
                if resp.status == 200:
                    raw_json = json.loads(resp.read().decode("utf-8"))
                    batch_data = raw_json.get("data", [])
                    for item in batch_data:
                        norm_item = normalize_nfc(item)
                        inp = norm_item.get("input") or norm_item.get("full_old_address")
                        if inp:
                            _save_to_cache(root_dir, inp, norm_item)
                        results.append(norm_item)
        except Exception:
            pass

    return results if results else None


def get_ward_rules(root_dir: Optional[Path | str] = None) -> List[Dict[str, str]]:
    """Return all merger rules: built-in combined with custom user-saved rules."""
    rules = list(DEFAULT_WARD_MERGERS)
    if root_dir:
        path = get_rules_file(root_dir)
        if path.is_file():
            try:
                custom = json.loads(path.read_text(encoding="utf-8"))
                if isinstance(custom, list):
                    existing_keys = {
                        (r.get("old_ward", "").lower(), r.get("district", "").lower())
                        for r in rules
                    }
                    for c in custom:
                        key = (c.get("old_ward", "").lower(), c.get("district", "").lower())
                        if key not in existing_keys:
                            rules.append(c)
                            existing_keys.add(key)
            except Exception:
                pass
    return rules


def save_custom_ward_rule(root_dir: Path | str, rule: Dict[str, str]) -> List[Dict[str, str]]:
    """Save a user-defined ward merger rule."""
    path = get_rules_file(root_dir)
    custom: List[Dict[str, str]] = []
    if path.is_file():
        try:
            loaded = json.loads(path.read_text(encoding="utf-8"))
            if isinstance(loaded, list):
                custom = loaded
        except Exception:
            pass

    old_target = rule.get("old_ward", "").strip().lower()
    dist_target = rule.get("district", "").strip().lower()
    custom = [
        c for c in custom
        if not (c.get("old_ward", "").strip().lower() == old_target and
                c.get("district", "").strip().lower() == dist_target)
    ]
    custom.append(rule)

    temp = path.with_suffix(".tmp")
    temp.write_text(json.dumps(custom, ensure_ascii=False, indent=2), encoding="utf-8")
    temp.replace(path)
    return get_ward_rules(root_dir)


def convert_address_old_to_new(
    address: str,
    root_dir: Optional[Path | str] = None,
    api_key: Optional[str] = None,
    use_geovina: bool = True
) -> Dict[str, Any]:
    """
    Convert a residential address from pre-merger (trước sáp nhập) to post-merger (sau sáp nhập).
    Uses the official GeoVina API (https://geovina.io.vn) with local caching and regex fallback.
    """
    address = (address or "").strip()
    if not address:
        return {
            "converted": False,
            "original": "",
            "result": "",
            "matched_old_ward": "",
            "matched_new_ward": "",
            "source": "none",
            "note": "Địa chỉ trống"
        }

    # 1. Primary: Use GeoVina API
    if use_geovina:
        try:
            geo = call_geovina_parse(address, root_dir=root_dir, api_key=api_key)
            if geo:
                new_addr = geo.get("full_new_address") or geo.get("ward_level_new_address")
                old_addr = geo.get("full_old_address") or geo.get("ward_level_old_address")
                mw = geo.get("matched_ward", {})
                new_ward_name = mw.get("name", "") if isinstance(mw, dict) else ""
                old_ward_name = geo.get("parsed_ward_raw", "")
                dist_name = geo.get("parsed_district_raw", "")
                prov_name = geo.get("parsed_province_raw", "")

                if new_addr:
                    new_addr_nfc = unicodedata.normalize("NFC", new_addr)
                    # If user entered detailed address with street/house number that got dropped by ward_level address,
                    # preserve the street/house part by replacing old ward with new ward
                    if old_ward_name and new_ward_name and old_ward_name.lower() in address.lower():
                        pattern = re.compile(re.escape(old_ward_name), re.IGNORECASE)
                        candidate = pattern.sub(new_ward_name, address, count=1)
                        if candidate.strip().lower() != address.strip().lower():
                            new_addr_nfc = unicodedata.normalize("NFC", candidate)
                    is_diff = new_addr_nfc.strip().lower() != address.strip().lower()
                    note = (
                        f"GeoVina API: Đã chuyển sang {new_ward_name}"
                        if new_ward_name else "GeoVina API: Đã chuẩn hóa và chuyển sang địa chỉ mới sau sáp nhập"
                    )
                    return {
                        "converted": is_diff or bool(new_ward_name),
                        "original": address,
                        "result": new_addr_nfc,
                        "matched_old_ward": old_ward_name,
                        "matched_new_ward": new_ward_name,
                        "district": dist_name,
                        "province": prov_name,
                        "source": "geovina_api",
                        "note": note,
                        "geovina": {
                            "mode": geo.get("mode"),
                            "old_address": old_addr,
                            "new_address": new_addr_nfc,
                            "matched_ward": mw
                        }
                    }
        except Exception:
            pass

    # 2. Secondary: Fallback to built-in local dictionary and regex matching
    rules = get_ward_rules(root_dir)
    sorted_rules = sorted(rules, key=lambda r: len(r.get("old_ward", "")), reverse=True)

    for rule in sorted_rules:
        old_ward = rule.get("old_ward", "").strip()
        new_ward = rule.get("new_ward", "").strip()
        if not old_ward or not new_ward or old_ward.lower() == new_ward.lower():
            continue

        pattern = re.escape(old_ward)
        if re.search(pattern, address, re.IGNORECASE):
            new_address = re.sub(pattern, new_ward, address, count=1, flags=re.IGNORECASE)
            return {
                "converted": True,
                "original": address,
                "result": unicodedata.normalize("NFC", new_address),
                "matched_old_ward": old_ward,
                "matched_new_ward": new_ward,
                "district": rule.get("district", ""),
                "province": rule.get("province", ""),
                "source": "local_rules",
                "note": f"Quy tắc nội bộ: {old_ward} ➔ {new_ward} ({rule.get('note', '')})"
            }

        short_old = re.sub(r"^(phường|xã|thị trấn)\s+", "", old_ward, flags=re.IGNORECASE).strip()
        short_new = re.sub(r"^(phường|xã|thị trấn)\s+", "", new_ward, flags=re.IGNORECASE).strip()
        if len(short_old) >= 3 and short_old.lower() != short_new.lower():
            short_pattern = r"(\b(?:P\.|Phường\s+|Xã\s+)?)" + re.escape(short_old) + r"(\b|,|\.|\s|$)"
            m = re.search(short_pattern, address, re.IGNORECASE)
            if m:
                prefix = m.group(1)
                suffix = m.group(2)
                replacement = f"{prefix}{short_new}{suffix}"
                new_address = address[:m.start()] + replacement + address[m.end():]
                return {
                    "converted": True,
                    "original": address,
                    "result": unicodedata.normalize("NFC", new_address),
                    "matched_old_ward": old_ward,
                    "matched_new_ward": new_ward,
                    "district": rule.get("district", ""),
                    "province": rule.get("province", ""),
                    "source": "local_rules",
                    "note": f"Quy tắc nội bộ: {short_old} ➔ {short_new} ({rule.get('note', '')})"
                }

    return {
        "converted": False,
        "original": address,
        "result": address,
        "matched_old_ward": "",
        "matched_new_ward": "",
        "source": "local_rules",
        "note": "Không tìm thấy tên phường/xã cũ trong cơ sở dữ liệu sáp nhập hoặc địa chỉ đã là phường mới."
    }


def convert_address_new_to_old(
    address: str,
    root_dir: Optional[Path | str] = None,
    api_key: Optional[str] = None,
    use_geovina: bool = True
) -> Dict[str, Any]:
    """
    Convert an address from post-merger (sau sáp nhập) back to pre-merger (trước sáp nhập).
    Leverages GeoVina's bidirectional address resolution with local rule fallback.
    """
    address = (address or "").strip()
    if not address:
        return {"converted": False, "original": "", "result": "", "note": "Địa chỉ trống", "source": "none"}

    # 1. GeoVina API (bidirectional parsing)
    if use_geovina:
        try:
            geo = call_geovina_parse(address, root_dir=root_dir, api_key=api_key)
            if geo:
                old_addr = geo.get("full_old_address")
                if old_addr:
                    old_addr_nfc = unicodedata.normalize("NFC", old_addr)
                    if old_addr_nfc.strip().lower() != address.strip().lower():
                        return {
                            "converted": True,
                            "original": address,
                            "result": old_addr_nfc,
                            "matched_old_ward": geo.get("parsed_ward_raw", ""),
                            "matched_new_ward": (geo.get("matched_ward") or {}).get("name", ""),
                            "source": "geovina_api",
                            "note": "GeoVina API: Đã chuyển về địa chỉ trước sáp nhập"
                        }
        except Exception:
            pass

    # 2. Local rules fallback
    rules = get_ward_rules(root_dir)
    sorted_rules = sorted(rules, key=lambda r: len(r.get("new_ward", "")), reverse=True)

    for rule in sorted_rules:
        old_ward = rule.get("old_ward", "").strip()
        new_ward = rule.get("new_ward", "").strip()
        if not old_ward or not new_ward or old_ward.lower() == new_ward.lower():
            continue

        pattern = re.escape(new_ward)
        if re.search(pattern, address, re.IGNORECASE):
            old_address = re.sub(pattern, old_ward, address, count=1, flags=re.IGNORECASE)
            return {
                "converted": True,
                "original": address,
                "result": unicodedata.normalize("NFC", old_address),
                "matched_old_ward": old_ward,
                "matched_new_ward": new_ward,
                "source": "local_rules",
                "note": f"Quy tắc nội bộ: {new_ward} ➔ {old_ward}"
            }

    return {
        "converted": False,
        "original": address,
        "result": address,
        "source": "local_rules",
        "note": "Không tìm thấy phường/xã sáp nhập tương ứng."
    }


def batch_convert_addresses(
    addresses: List[str],
    root_dir: Optional[Path | str] = None,
    api_key: Optional[str] = None
) -> List[Dict[str, Any]]:
    """
    Batch convert multiple addresses using GeoVina batch API where possible,
    falling back to individual conversion for uncached/failed items.
    """
    clean_list = [str(a).strip() for a in addresses]
    if not clean_list:
        return []

    # First attempt GeoVina batch API
    batch_res = call_geovina_batch(clean_list, root_dir=root_dir, api_key=api_key)
    res_map = {}
    if batch_res:
        for item in batch_res:
            inp = item.get("input", "")
            if inp:
                res_map[inp.strip().lower()] = item

    results = []
    for addr in clean_list:
        if not addr:
            results.append({"converted": False, "original": "", "result": ""})
            continue

        cached_item = res_map.get(addr.strip().lower())
        if cached_item and cached_item.get("full_new_address"):
            new_addr = unicodedata.normalize("NFC", cached_item["full_new_address"])
            mw = cached_item.get("matched_ward", {})
            wname = mw.get("name", "") if isinstance(mw, dict) else ""
            results.append({
                "converted": new_addr.strip().lower() != addr.strip().lower(),
                "original": addr,
                "result": new_addr,
                "matched_new_ward": wname,
                "source": "geovina_api",
                "note": f"GeoVina API: Đã chuyển đổi sang {wname}" if wname else "GeoVina API"
            })
        else:
            # Fall back to single conversion (checks cache and local rules)
            results.append(convert_address_old_to_new(addr, root_dir=root_dir, api_key=api_key))

    return results


def evaluate_growth(weight: Any, height: Any) -> Dict[str, Any]:
    """
    Evaluate child weight and height measurements according to standard preschool nutrition thresholds.
    Calculates BMI: weight (kg) / (height (m))^2.
    """
    try:
        w = float(str(weight).replace(",", ".").strip()) if weight else 0.0
    except (ValueError, TypeError):
        w = 0.0

    try:
        h = float(str(height).replace(",", ".").strip()) if height else 0.0
    except (ValueError, TypeError):
        h = 0.0

    bmi = 0.0
    status = "Chưa có đủ số đo"
    color = "#668077"

    if w > 0 and h > 0:
        h_m = h / 100.0
        bmi = round(w / (h_m * h_m), 1)

        # Standard WHO / Ministry of Health preschool BMI thresholds (approx. ages 2–6)
        if bmi < 13.5:
            status = "Suy dinh dưỡng (Nhẹ cân / Thấp còi)"
            color = "#D9534F"
        elif 13.5 <= bmi <= 17.5:
            status = "Bình thường (Kênh A)"
            color = "#207465"
        elif 17.5 < bmi <= 19.0:
            status = "Nguy cơ thừa cân"
            color = "#F0AD4E"
        else:
            status = "Thừa cân / Béo phì"
            color = "#D9534F"
    elif w > 0:
        status = f"Đã ghi cân nặng ({w} kg)"
        color = "#207465"
    elif h > 0:
        status = f"Đã ghi chiều cao ({h} cm)"
        color = "#207465"

    return {
        "weight": w,
        "height": h,
        "bmi": bmi,
        "status": status,
        "color": color
    }
