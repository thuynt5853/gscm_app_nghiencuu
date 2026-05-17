using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.DONKHOIKIEN.Personnal.TempBM;

using System.Globalization;
using BL.DonKK;
using BL.DonKK.DanhMuc;

using BL.GSTP;
using BL.GSTP.Danhmuc;

using System.Data;

namespace WEB.DONKHOIKIEN.Personnal
{
    public partial class InBC : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext dtgstp = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    string LoaiAn = "";// String.IsNullOrEmpty(Request["loaivv"] + "") ? "" : Request["loaivv"].ToString();
                    decimal DonID = String.IsNullOrEmpty(Request["dkkID"] + "") ? 0 : Convert.ToDecimal(Request["dkkID"] + "");
                    String GroupDangKyVBTongData = String.IsNullOrEmpty(Request["groupid"] + "") ? "" : Request["groupid"].ToString(),
                        EditMucDichSuDung = String.IsNullOrEmpty(Request["type"] + "") ? "" : Request["type"].ToString();

                    if (DonID > 0)
                    {
                        DONKK_DON don = dt.DONKK_DON.Where(x => x.ID == DonID).FirstOrDefault();
                        if (don != null)
                        {
                            LoaiAn = don.MALOAIVUAN;
                            switch (LoaiAn)
                            {
                                case ENUM_LOAIAN.AN_DANSU:
                                    LoadReportADS(don);
                                    break;
                                case ENUM_LOAIAN.AN_HANHCHINH:
                                    LoadReportAHC(don);
                                    break;
                            }
                        }
                    }
                    else if (GroupDangKyVBTongData.Length > 0)
                    {
                        LoadReport_DKNhanVBTongDat();
                    }
                    else if (EditMucDichSuDung == "editmucdichsd")
                    {
                        LoadReport_DoiMucDichSuDungTK();
                    }
                    else
                        Cls_Comon.ShowMsgAnClosePopup(this, this.GetType(), "Bạn chưa chọn đối tượng cần in!");

                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        #region Report don khoi kien
        private void LoadReportADS(DONKK_DON don)
        {
                DTBIEUMAU dtbm = new DTBIEUMAU();
                DTBIEUMAU.DTBM23DSRow r = dtbm.DTBM23DS.NewDTBM23DSRow();
                r.DiaDiem = getDiaDiem(don.TOAANID);
                try
                {
                    DateTime oNgayTao = (DateTime)don.NGAYTAO;
                    r.Ngay = oNgayTao.Day.ToString();
                    r.Thang = oNgayTao.Month.ToString();
                    r.Nam = oNgayTao.Year.ToString();
                }
                catch { }
                r.ThongTinKhac = don.THONGTINTHEM;
                r.NoiDungDon = don.NOIDUNG;
                r.TenToaAn = getTenToa(don.TOAANID);
                r.TenToaAn_DiaChi = getDiaDiem_ToaAn(don.TOAANID);
                r.TenNguoiKK = getNguoiKhoiKien(don);
                dtbm.DTBM23DS.AddDTBM23DSRow(r);
                dtbm.AcceptChanges();

                List<DONKK_DON_DUONGSU> lstND = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
                List<DONKK_DON_DUONGSU> lstBD = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                List<DONKK_DON_DUONGSU> lstQUYENDUOCBV = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENLOIICHDUOCBAOVE).ToList();
                List<DONKK_DON_DUONGSU> lstQUYENNVLQ = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
                List<DONKK_DON_DUONGSU> lstNguoiLamChung = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUOILAMCHUNG).ToList();
                List<DONKK_DON_TAILIEU> lstTaiLieu = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == don.ID).ToList();
                // Nguyên đơn
                if (lstND.Count > 0)
                {
                    dtbm = FillDSNguyenDon(dtbm, lstND);
                }
                // Bị đơn
                if (lstBD.Count > 0)
                {
                    dtbm = FillDSBiDon(dtbm, lstBD);
                }
                // Người có quyền, lợi ích được bảo vệ
                if (lstQUYENDUOCBV.Count > 0)
                {
                    dtbm = FillDSQuyenDuocBaoVe(dtbm, lstQUYENDUOCBV);
                }
                // Người có quyền lợi, nghĩa vụ liên quan
                if (lstQUYENNVLQ.Count > 0)
                {
                    dtbm = FillDSQuyenNVLQ(dtbm, lstQUYENNVLQ);
                }
                // Người làm chứng
                if (lstNguoiLamChung.Count > 0)
                {
                    dtbm = FillDSNhanChung(dtbm, lstNguoiLamChung);
                }
                // Danh sách tài liệu đính kèm
                if (lstTaiLieu.Count > 0)
                {
                    dtbm = FillDSTaiLieu(dtbm, lstTaiLieu);
                }


            
            rpt23DS rpt = new rpt23DS();
            rpt.DataSource = dtbm;
            rptView.OpenReport(rpt);
        }
        private void LoadReportAHC(DONKK_DON don)
        {
            DTBIEUMAU dtbm = new DTBIEUMAU();
            DTBIEUMAU.DTBM01HCRow r = dtbm.DTBM01HC.NewDTBM01HCRow();
            r.DiaDiem = getDiaDiem(don.TOAANID);
            try
            {
                DateTime oNgayTao = (DateTime)don.NGAYTAO;
                r.Ngay = oNgayTao.Day.ToString();
                r.Thang = oNgayTao.Month.ToString();
                r.Nam = oNgayTao.Year.ToString();
            }
            catch { }
            r.TenToaAn = getTenToa(don.TOAANID);
            r.TenToaAn_DiaChi = getDiaDiem_ToaAn(don.TOAANID);
            r.NoiDungDon = don.NOIDUNG;
            r.TenQD = don.TENQD;
            r.SoQD = don.SOQD;
            try
            {
                DateTime oNgayQD = (DateTime)don.NGAYQD;
                r.NgayQD = oNgayQD.Day.ToString();
                r.ThangQD = oNgayQD.Month.ToString();
                r.NamQD = oNgayQD.Year.ToString();
            }
            catch { }
            decimal qdhcID = don.LOAIQDHANHCHINHID + "" == "" ? 0 : (decimal)don.LOAIQDHANHCHINHID;
            DM_DATAITEM qdhc = dtgstp.DM_DATAITEM.Where(x => x.ID == qdhcID).FirstOrDefault();
            if (qdhc != null)
            {
                r.QDHanhChinh = qdhc.TEN;
            }
            r.QDHanhChinh_Cua = don.QDHC_CUA;
            r.HanhViHC = don.HANHVIHC;
            r.TomTatHanhViHCBiKien = don.TOMTATHANHVIHCBIKIEN;
            r.NoiDungQuyetDinh = don.NOIDUNGQUYETDINH;
            r.TenNguoiKK = getNguoiKhoiKien(don);
            dtbm.DTBM01HC.AddDTBM01HCRow(r);
            dtbm.AcceptChanges();

            List<DONKK_DON_DUONGSU> lstND = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).ToList();
            List<DONKK_DON_DUONGSU> lstBD = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<DONKK_DON_DUONGSU> lstQUYENNVLQ = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<DONKK_DON_TAILIEU> lstTaiLieu = dt.DONKK_DON_TAILIEU.Where(x => x.DONID == don.ID).ToList();
            // Nguyên đơn
            if (lstND.Count > 0)
            {
                dtbm = FillDSNguyenDon(dtbm, lstND);
            }
            // Bị đơn
            if (lstBD.Count > 0)
            {
                dtbm = FillDSBiDon(dtbm, lstBD);
            }
            // Người có quyền lợi, nghĩa vụ liên quan
            if (lstQUYENNVLQ.Count > 0)
            {
                dtbm = FillDSQuyenNVLQ(dtbm, lstQUYENNVLQ);
            }
            // Danh sách tài liệu đính kèm
            if (lstTaiLieu.Count > 0)
            {
                dtbm = FillDSTaiLieu(dtbm, lstTaiLieu);
            }
            rpt01HC rpt = new rpt01HC();
            rpt.DataSource = dtbm;
            rptView.OpenReport(rpt);
        }
        private DTBIEUMAU FillDSNguyenDon(DTBIEUMAU dtbm, List<DONKK_DON_DUONGSU> lst)
        {
            DM_HANHCHINH hc = null; decimal TamTruID = 0;
            foreach (DONKK_DON_DUONGSU item in lst)
            {
                DTBIEUMAU.DTNGUYENDONRow rt = dtbm.DTNGUYENDON.NewDTNGUYENDONRow();
                DTBIEUMAU.DTNGUYENDON_KYRow rk = dtbm.DTNGUYENDON_KY.NewDTNGUYENDON_KYRow();
                if (item.LOAIDUONGSU != 1)// cơ quan, tổ chức
                {
                    rt.Ten = item.TENDUONGSU + "; Người đại diện hợp pháp: " + ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.NGUOIDAIDIEN;
                    TamTruID = (decimal)item.NDD_DIACHIID;
                    rk.Ten = item.TENDUONGSU;
                }
                else
                {
                    rt.Ten = rk.Ten = ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.TENDUONGSU;
                    TamTruID = (decimal)item.TAMTRUID;
                }
                hc = dtgstp.DM_HANHCHINH.Where(x => x.ID == TamTruID).FirstOrDefault();
                if (hc != null)
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "" == "" ? hc.MA_TEN : item.TAMTRUCHITIET + ", " + hc.MA_TEN;
                }
                else
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "";
                }
                rt.SoDienThoai = item.DIENTHOAI;
                rt.Fax = item.FAX;
                rt.Email = item.EMAIL;
                dtbm.DTNGUYENDON.AddDTNGUYENDONRow(rt);
                dtbm.DTNGUYENDON_KY.AddDTNGUYENDON_KYRow(rk);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private DTBIEUMAU FillDSBiDon(DTBIEUMAU dtbm, List<DONKK_DON_DUONGSU> lst)
        {
            DM_HANHCHINH hc = null; decimal TamTruID = 0;
            foreach (DONKK_DON_DUONGSU item in lst)
            {
                DTBIEUMAU.DTBIDONRow rt = dtbm.DTBIDON.NewDTBIDONRow();
                if (item.LOAIDUONGSU != 1)// cơ quan, tổ chức
                {
                    rt.Ten = item.TENDUONGSU + "; Người đại diện hợp pháp: " + ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.NGUOIDAIDIEN;
                    TamTruID = (decimal)item.NDD_DIACHIID;
                }
                else
                {
                    rt.Ten = ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.TENDUONGSU;
                    TamTruID = (decimal)item.TAMTRUID;
                }
                hc = dtgstp.DM_HANHCHINH.Where(x => x.ID == TamTruID).FirstOrDefault();
                if (hc != null)
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "" == "" ? hc.MA_TEN : item.TAMTRUCHITIET + ", " + hc.MA_TEN;
                }
                else
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "";
                }
                rt.SoDienThoai = item.DIENTHOAI;
                rt.Fax = item.FAX;
                rt.Email = item.EMAIL;
                dtbm.DTBIDON.AddDTBIDONRow(rt);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private DTBIEUMAU FillDSQuyenDuocBaoVe(DTBIEUMAU dtbm, List<DONKK_DON_DUONGSU> lst)
        {
            DM_HANHCHINH hc = null; decimal TamTruID = 0;
            foreach (DONKK_DON_DUONGSU item in lst)
            {
                DTBIEUMAU.DTQUYENDUOCBAOBERow rt = dtbm.DTQUYENDUOCBAOBE.NewDTQUYENDUOCBAOBERow();
                if (item.LOAIDUONGSU != 1)// cơ quan, tổ chức
                {
                    rt.Ten = item.TENDUONGSU + "; Người đại diện hợp pháp: " + ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.NGUOIDAIDIEN;
                    TamTruID = (decimal)item.NDD_DIACHIID;
                }
                else
                {
                    rt.Ten = ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.TENDUONGSU;
                    TamTruID = (decimal)item.TAMTRUID;
                }
                hc = dtgstp.DM_HANHCHINH.Where(x => x.ID == TamTruID).FirstOrDefault();
                if (hc != null)
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "" == "" ? hc.MA_TEN : item.TAMTRUCHITIET + ", " + hc.MA_TEN;
                }
                else
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "";
                }
                rt.SoDienThoai = item.DIENTHOAI;
                rt.Fax = item.FAX;
                rt.Email = item.EMAIL;
                dtbm.DTQUYENDUOCBAOBE.AddDTQUYENDUOCBAOBERow(rt);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private DTBIEUMAU FillDSQuyenNVLQ(DTBIEUMAU dtbm, List<DONKK_DON_DUONGSU> lst)
        {
            DM_HANHCHINH hc = null; decimal TamTruID = 0;
            foreach (DONKK_DON_DUONGSU item in lst)
            {
                DTBIEUMAU.DTNVLQRow rt = dtbm.DTNVLQ.NewDTNVLQRow();
                if (item.LOAIDUONGSU != 1)// cơ quan, tổ chức
                {
                    rt.Ten = item.TENDUONGSU + "; Người đại diện hợp pháp: " + ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.NGUOIDAIDIEN;
                    TamTruID = (decimal)item.NDD_DIACHIID;
                }
                else
                {
                    rt.Ten = ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.TENDUONGSU;
                    TamTruID = (decimal)item.TAMTRUID;
                }
                hc = dtgstp.DM_HANHCHINH.Where(x => x.ID == TamTruID).FirstOrDefault();
                if (hc != null)
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "" == "" ? hc.MA_TEN : item.TAMTRUCHITIET + ", " + hc.MA_TEN;
                }
                else
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "";
                }
                rt.SoDienThoai = item.DIENTHOAI;
                rt.Fax = item.FAX;
                rt.Email = item.EMAIL;
                dtbm.DTNVLQ.AddDTNVLQRow(rt);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private DTBIEUMAU FillDSNhanChung(DTBIEUMAU dtbm, List<DONKK_DON_DUONGSU> lst)
        {
            DM_HANHCHINH hc = null; decimal TamTruID = 0;
            foreach (DONKK_DON_DUONGSU item in lst)
            {
                DTBIEUMAU.DTNGUOILAMCHUNGRow rt = dtbm.DTNGUOILAMCHUNG.NewDTNGUOILAMCHUNGRow();
                if (item.LOAIDUONGSU != 1)// cơ quan, tổ chức
                {
                    rt.Ten = item.TENDUONGSU + "; Người đại diện hợp pháp: " + ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.NGUOIDAIDIEN;
                    TamTruID = (decimal)item.NDD_DIACHIID;
                }
                else
                {
                    rt.Ten = ConvertGioiTinhToString((decimal)item.GIOITINH) + " " + item.TENDUONGSU;
                    TamTruID = (decimal)item.TAMTRUID;
                }
                hc = dtgstp.DM_HANHCHINH.Where(x => x.ID == TamTruID).FirstOrDefault();
                if (hc != null)
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "" == "" ? hc.MA_TEN : item.TAMTRUCHITIET + ", " + hc.MA_TEN;
                }
                else
                {
                    rt.DiaChi = item.TAMTRUCHITIET + "";
                }
                rt.SoDienThoai = item.DIENTHOAI;
                rt.Fax = item.FAX;
                rt.Email = item.EMAIL;
                dtbm.DTNGUOILAMCHUNG.AddDTNGUOILAMCHUNGRow(rt);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private DTBIEUMAU FillDSTaiLieu(DTBIEUMAU dtbm, List<DONKK_DON_TAILIEU> lst)
        {
            DM_HANHCHINH hc = null;
            Int16 tt = 1;
            foreach (DONKK_DON_TAILIEU item in lst)
            {
                DTBIEUMAU.DTTAILIEURow rt = dtbm.DTTAILIEU.NewDTTAILIEURow();
                rt.TT = tt.ToString();
                rt.Ten = item.TENTAILIEU + "" == "" ? item.TENFILE : item.TENTAILIEU;
                dtbm.DTTAILIEU.AddDTTAILIEURow(rt);
                tt++;
            }
            dtbm.AcceptChanges();
            return dtbm;
        }
        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dtgstp.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân ", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dtgstp.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân ", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp." + strDiadiem;
                        break;
                }
                return strDiadiem;
            }
            catch { return ""; }
        }
        private string getTenToa(decimal TOAANID)
        {
            try
            {
                string strTenToa = "";
                DM_TOAAN oT = dtgstp.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault();
                strTenToa = oT.MA_TEN;
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getDiaDiem_ToaAn(decimal TOAANID)
        {
            try
            {
                string strTenToa = "";
                DM_TOAAN oT = dtgstp.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault();
                strTenToa = oT.DIACHI;
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getNguoiKhoiKien(DONKK_DON don)
        {
            string NguoiKK_Ten = "";
            DONKK_DON_DUONGSU ds = dt.DONKK_DON_DUONGSU.Where(x => x.DONKKID == don.ID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).FirstOrDefault();
            if (ds != null)
            {
                NguoiKK_Ten = ds.TENDUONGSU;
            }
            return NguoiKK_Ten;
        }
        private string ConvertGioiTinhToString(decimal GioiTinh)
        {
            string re = "Ông";
            if (GioiTinh == 0)
            {
                re = "Bà";
            }
            return re;
        }
        #endregion
        private void LoadReport_DKNhanVBTongDat()
        {
            DTBIEUMAU dtbm = new DTBIEUMAU();
            String GroupDKyID = String.IsNullOrEmpty(Request["groupid"] + "") ? "" : Request["groupid"].ToString();
            DOnKK_User_DKNhanVB_BL obj = new DOnKK_User_DKNhanVB_BL();
            DataTable tbl = obj.GetInfoDangKyNhanVB(GroupDKyID);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                DTBIEUMAU.VBTONGDAT_NGUOIYCRow RNguoiYC = dtbm.VBTONGDAT_NGUOIYC.NewVBTONGDAT_NGUOIYCRow();
                DataRow root = tbl.Rows[0];
                RNguoiYC.TenToaAn = root["TenToaAn"] + "";
                RNguoiYC.TenDuongSu = root["UserHoTen"] + "";
                RNguoiYC.CMND = root["UserCMND"] + "";
                RNguoiYC.NgaySinh = root["UserNgaySinh"] + "" == "" ? "" : Convert.ToDateTime(root["UserNgaySinh"]).ToString("dd/MM/yyyy");
                RNguoiYC.HKThuongTru = root["UserHKThuongTru"] + "" == "" ? root["HKThuongTru_TinhHuyen"] + "" : root["UserHKThuongTru"] + ", " + root["HKThuongTru_TinhHuyen"];
                RNguoiYC.HKTamTru = root["UserHKTamTru"] + "" == "" ? root["HKTamTru_TinhHuyen"] + "" : root["UserHKTamTru"] + ", " + root["HKTamTru_TinhHuyen"];
                RNguoiYC.DienThoai = root["UserDienThoai"] + "";
                RNguoiYC.Email = root["UserEmail"] + "";
                RNguoiYC.NgayDangKy = root["NgayTao"] + "" == "" ? "" : Convert.ToDateTime(root["NgayTao"]).ToString("dd/MM/yyyy");
                RNguoiYC.MaDangKy = root["MaDangKy"] + "";
                dtbm.VBTONGDAT_NGUOIYC.AddVBTONGDAT_NGUOIYCRow(RNguoiYC);
                // fill danh sách yêu cầu
                foreach (DataRow row in tbl.Rows)
                {
                    DTBIEUMAU.VBTONGDAT_DANHSACHYCRow RDanhSachYC = dtbm.VBTONGDAT_DANHSACHYC.NewVBTONGDAT_DANHSACHYCRow();
                    RDanhSachYC.STT = row["stt"] + "";
                    RDanhSachYC.MaVuViec = row["MaVuViec"] + "";
                    RDanhSachYC.TenVuViec = row["TenVuViec"] + "";
                    RDanhSachYC.LoaiVuViec = row["LoaiVuAn"] + "";
                    RDanhSachYC.TuCachToTung = row["TenTuCachToTung"] + "";
                    RDanhSachYC.TrangThaiDuyet = row["TrangThaiDuyet"] + "";
                    dtbm.VBTONGDAT_DANHSACHYC.AddVBTONGDAT_DANHSACHYCRow(RDanhSachYC);
                }
                dtbm.AcceptChanges();
                rptVBTongDat rpt = new rptVBTongDat();
                rpt.DataSource = dtbm;
                rptView.OpenReport(rpt);
            }
        }
        private void LoadReport_DoiMucDichSuDungTK()
        {
            DTBIEUMAU dtbm = new DTBIEUMAU();
            DTBIEUMAU.DTDOIMUCDICHSUDUNGTAIKHOANRow r = dtbm.DTDOIMUCDICHSUDUNGTAIKHOAN.NewDTDOIMUCDICHSUDUNGTAIKHOANRow();
            DateTime Today = DateTime.Today;
            r.NGAY = Today.Day.ToString();
            r.THANG = Today.Month.ToString();
            r.NAM = Today.Year.ToString();
            decimal UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            DONKK_USERS oUser = dt.DONKK_USERS.Where(x => x.ID == UserID).FirstOrDefault();
            if (oUser != null)
            {
                r.TENNGUOIDK = oUser.NDD_HOTEN + "";
                r.HOTEN_OLD = oUser.NDD_HOTEN + "";
                r.CMND_OLD = oUser.NDD_CMND + "";
                r.EMAIL_OLD = oUser.EMAIL + "";
            }
            DONKK_USER_DOIMUCDICHSD oDoiMDSD = dt.DONKK_USER_DOIMUCDICHSD.Where(x => x.USERID == UserID).FirstOrDefault();
            if (oDoiMDSD != null)
            {
                decimal ToaAnID = oDoiMDSD.TOAANNHANID + "" == "" ? 0 : (decimal)oDoiMDSD.TOAANNHANID;
                DM_TOAAN ToaAn = dtgstp.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                if (ToaAn != null)
                {
                    r.TENTOAAN = ToaAn.MA_TEN + "";
                }
                r.MADANGKY = oDoiMDSD.MADANGKY + "";
                r.HOTEN_NEW = oDoiMDSD.HOTEN_NEW + "";
                r.CMND_NEW = oDoiMDSD.CMND_NEW + "";
                r.EMAIL_NEW = oDoiMDSD.EMAIL_NEW + "";
            }
            dtbm.DTDOIMUCDICHSUDUNGTAIKHOAN.AddDTDOIMUCDICHSUDUNGTAIKHOANRow(r);
            dtbm.AcceptChanges();
            //DateTime.Today.Day;
            rptChuyenMucDichSuDungTK rpt = new rptChuyenMucDichSuDungTK();
            rpt.DataSource = dtbm;
            rptView.OpenReport(rpt);
        }
    }
}