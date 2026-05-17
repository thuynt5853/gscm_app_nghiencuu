# Tai lieu luong nhap AHS va map du lieu

Tai lieu nay tong hop cac man hinh/luong da duoc hoi trong branch `nghiencuu_cursor_clean`.

## 1. Kien truc luong chung

Du an la ASP.NET WebForms/C# dung Oracle.

```text
Man hinh .aspx/.ascx
  -> code-behind .aspx.cs/.ascx.cs
  -> GSTPContext Entity Framework hoac BL.* class
  -> Oracle DB / stored procedure
```

Nhung man hinh trong tai lieu nay chu yeu luu bang `GSTPContext dt = new GSTPContext()` vao cac bang `AHS_*`.

## 2. Man hinh tao ho so KC/KN

URL:

```text
/QLAN/AHS/TaoHS/TaoHosoKC.aspx
```

File:

```text
WEB/WEB.GSTP/QLAN/AHS/TaoHS/TaoHosoKC.aspx
WEB/WEB.GSTP/QLAN/AHS/TaoHS/TaoHosoKC.aspx.cs
```

Luung luu chinh:

```text
Luu Ho so
  -> cmdUpdateVuAn_Click
  -> SaveData()
  -> SaveDataVuAn()
  -> AHS_VUAN
  -> UpdateBanAn() hoac UpdateQuyetDinh()
  -> Chuyenan_Nhanan()
  -> UpdateKhangCaoKN()
```

Bang chinh:

- `AHS_VUAN`
- `AHS_SOTHAM_BANAN`
- `AHS_SOTHAM_QUYETDINH_VUAN`
- `AHS_CHUYEN_NHAN_AN`
- `AHS_VUAN_GIAIDOAN`
- `AHS_SOTHAM_KHANGCAO`
- `AHS_SOTHAM_KHANGCAO_YEUCAU`
- `AHS_SOTHAM_KHANGNGHI`
- `AHS_SOTHAM_KHANGNGHI_YEUCAU`
- `AHS_BICANBICAO`
- `AHS_BICAN_NHANTHAN`
- `AHS_SOTHAM_CAOTRANG_DIEULUAT`
- `AHS_NGUOITHAMGIATOTUNG`
- `AHS_NGUOITHAMGIATOTUNG_TUCACH`

Ghi chu: truong `Ngay nhan Ho so` co control `txtNgayNhanHS`, nhung code hien set `AHS_CHUYEN_NHAN_AN.NGAYNHAN = DateTime.Now`.

## 3. Man hinh thong tin an

URL:

```text
/QLAN/AHS/Hoso/thongtinan.aspx?type=list
```

File:

```text
WEB/WEB.GSTP/QLAN/AHS/Hoso/Thongtinan.aspx
WEB/WEB.GSTP/QLAN/AHS/Hoso/Thongtinan.aspx.cs
```

Luung luu chinh:

```text
Luu
  -> cmdUpdateVuAn_Click
  -> SaveData()
  -> SaveDataVuAn()
  -> AHS_VUAN
```

Neu chon `Thu ly vu an = Co`:

```text
SaveData()
  -> Save_ThuLy()
  -> ThemThuLyHS()
  -> AHS_SOTHAM_THULY
```

Khi tao moi ho so, code goi:

```text
GIAI_DOAN_BL.GAIDOAN_INSERT_UPDATE(...)
  -> PKG_STPT.GAIDOAN_IN_UP
  -> AHS_VUAN_GIAIDOAN
```

Bang chinh:

- `AHS_VUAN`
- `AHS_SOTHAM_THULY`
- `AHS_VUAN_GIAIDOAN`

## 4. Popup bi can trong ho so

URL:

```text
/QLAN/AHS/Hoso/popup/pBiCao.aspx?hsID=326049
```

File:

```text
WEB/WEB.GSTP/QLAN/AHS/Hoso/Popup/pBiCao.aspx
WEB/WEB.GSTP/QLAN/AHS/Hoso/Popup/pBiCao.aspx.cs
```

`hsID` duoc gan vao:

```text
AHS_BICANBICAO.VUANID
```

Luung luu chinh:

```text
Luu va thoat / Luu va nhap tiep
  -> cmdUpdate_Click / cmdUpdateAndNext_Click
  -> Save_BiCan()
  -> Update_BiCao()
  -> AHS_BICANBICAO
  -> SaveNhanThanBiCan()
  -> AHS_BICAN_NHANTHAN
  -> SaveBienPhapNC()
  -> AHS_SOTHAM_BIENPHAPNGANCHAN
```

Khi luu dieu luat/toi danh:

```text
cmdThemDieuLuat_Click
  -> InsertToiDanh(...)
  -> AHS_SOTHAM_CAOTRANG_DIEULUAT
```

Bang chinh:

- `AHS_BICANBICAO`
- `AHS_BICAN_NHANTHAN`
- `AHS_SOTHAM_BIENPHAPNGANCHAN`
- `AHS_SOTHAM_CAOTRANG_DIEULUAT`
- `AHS_BICANBICAO_HISTORY` (khi sua bi can, goi BL ghi lich su)

## 5. Popup nguoi tham gia to tung trong ho so

URL:

```text
/QLAN/AHS/Hoso/Popup/pNguoiThamGiaTT.aspx?hsID=326049
```

File:

```text
WEB/WEB.GSTP/QLAN/AHS/Hoso/Popup/pNguoiThamGiaTT.aspx
WEB/WEB.GSTP/QLAN/AHS/Hoso/Popup/pNguoiThamGiaTT.aspx.cs
```

`hsID` duoc gan vao:

```text
AHS_NGUOITHAMGIATOTUNG.VUANID
```

Luung luu chinh:

```text
Luu & Thoat / Luu & Them moi
  -> btnUpdate_Click / cmdUpdateAndNext_Click
  -> SaveData()
  -> AHS_NGUOITHAMGIATOTUNG
  -> UpdateTuCach()
  -> AHS_NGUOITHAMGIATOTUNG_TUCACH
```

Bang chinh:

- `AHS_NGUOITHAMGIATOTUNG`
- `AHS_NGUOITHAMGIATOTUNG_TUCACH`

## 6. File Excel map label -> bang.cot

File Excel di kem:

```text
docs/map-label-bang-cot-ahs.xlsx
```

Quy uoc:

- Moi sheet la mot bang DB.
- Moi dong la mot label/control tren man hinh.
- Cot `Screen` cho biet man hinh/popup phat sinh du lieu.
- Cot `Label` la text hien thi tren giao dien.
- Cot `Control` la ID control WebForms.
- Cot `Column` la cot du lieu trong bang cua sheet.
- Cot `Source/Logic` ghi ham/code luu du lieu hoac ghi chu dac biet.
- Cot `Is Lookup` danh dau truong co lay tu danh muc/dropdown/radio hardcode.
- Cot `Lookup Name/Group` ghi ten nhom danh muc, enum, hoac bang nguon.
- Cot `Lookup Source` ghi bang/procedure/code dung de load danh muc.
- Cot `Hardcoded/Filter Values` ghi cac ma hardcode hoac dieu kien loc danh muc.
