using BL.GSTP;
using BL.GSTP.AHC;
using BL.GSTP.TP_THADS;
using DAL.GSTP;
using Microsoft.Reporting.WebForms;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class ViewReport : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWord"];
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    decimal vDonID = 0;
                    if (Session[ENUM_LOAIAN.AN_HANHCHINH] != null)
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                    AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                    if (oDon != null)
                    {
                        if (oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDon.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM)
                            LoadReport_ST(vDonID);
                        else
                            LoadReport_PT(vDonID);
                    }
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        private string getTenToa(decimal TOAANID)
        {
            try
            {
                string strTenToa = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == TOAANID).FirstOrDefault();
                strTenToa = oT.MA_TEN;
                if (strTenToa.Contains("cấp cao"))
                {
                    strTenToa = strTenToa.Replace("cấp cao", "cấp cao\n");
                }
                else if (!strTenToa.Contains("tối cao"))
                {
                    strTenToa = strTenToa.Replace("Tòa án nhân dân", "TAND").Replace(",", "\n"); ;
                }
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getVKS(decimal VKSID)
        {
            try
            {
                string strTenToa = "";
                DM_VKS oT = dt.DM_VKS.Where(x => x.ID == VKSID).FirstOrDefault();
                strTenToa = oT.TEN;
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getCanBo(decimal CanboID)
        {
            try
            {
                string strTenToa = "";
                DM_CANBO oT = dt.DM_CANBO.Where(x => x.ID == CanboID).FirstOrDefault();
                strTenToa = oT.HOTEN;
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getDiachi(decimal HuyenID)
        {
            try
            {
                string strTenToa = "";
                DM_HANHCHINH oT = dt.DM_HANHCHINH.Where(x => x.ID == HuyenID).FirstOrDefault();
                strTenToa = oT.MA_TEN;
                return strTenToa;
            }
            catch (Exception ex) { return ""; }
        }
        private string getDiaDiem(decimal ToaAnID)
        {
            try
            {
                string strDiadiem = "";
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
                strDiadiem = oT.TEN.Replace("Tòa án nhân dân", "");
                switch (oT.LOAITOA)
                {
                    case "CAPHUYEN":
                        DM_TOAAN opT = dt.DM_TOAAN.Where(x => x.ID == oT.CAPCHAID).FirstOrDefault();
                        strDiadiem = opT.TEN.Replace("Tòa án nhân dân", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPTINH":
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                    case "CAPCAO":
                        strDiadiem = strDiadiem.Replace("cấp cao", "");
                        strDiadiem = strDiadiem.Replace("tỉnh", "");
                        strDiadiem = strDiadiem.Replace("Tỉnh", "");
                        strDiadiem = strDiadiem.Replace("thành phố", "");
                        strDiadiem = strDiadiem.Replace("Thành phố", "");
                        strDiadiem = strDiadiem.Replace("tại", "");
                        if (strDiadiem.Contains("Hồ Chí Minh"))
                            strDiadiem = "Tp. " + strDiadiem.Trim();
                        break;
                }
                return strDiadiem;
            }
            catch (Exception ex) { return ""; }
        }
        private string getDataItem(decimal ItemID)
        {
            try
            {
                DM_DATAITEM oT = dt.DM_DATAITEM.Where(x => x.ID == ItemID).FirstOrDefault();
                return oT.TEN;
            }
            catch { return ""; }
        }
        private string getQuanhephapluat_name(string loaian, string don_st_pt, string tl_ba, decimal DONID)
        {
            string quanhephapluat_name = "";
            if (loaian == "AHC")
            {
                if (don_st_pt == "DON")
                {
                    AHC_DON oT = dt.AHC_DON.Where(x => x.ID == DONID).FirstOrDefault();
                    if (oT.QUANHEPHAPLUAT_NAME != null && oT.QUANHEPHAPLUAT_NAME != "")
                    {
                        quanhephapluat_name = oT.QUANHEPHAPLUAT_NAME;
                    }
                    else if (oT.QUANHEPHAPLUATID != null && oT.QUANHEPHAPLUATID != 0)
                    {
                        quanhephapluat_name = getDataItem(Convert.ToDecimal(oT.QUANHEPHAPLUATID));
                        //decimal IDQHPL = Convert.ToDecimal(oT.QUANHEPHAPLUATID.ToString());
                        //DM_DATAITEM obj = dt.DM_DATAITEM.Where(x => x.ID == IDQHPL).FirstOrDefault();
                        //quanhephapluat_name = obj.TEN.ToString();
                    }
                    else if ((oT.QUANHEPHAPLUAT_NAME != null && oT.QUANHEPHAPLUATID != null)
                            && (oT.QUANHEPHAPLUAT_NAME != "" && oT.QUANHEPHAPLUATID != null))
                    {
                        quanhephapluat_name = "";
                    }
                }
                else if (don_st_pt == "SOTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        AHC_SOTHAM_THULY oND = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(DONID);
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        AHC_PHUCTHAM_THULY oND = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(DONID);
                        }
                    }
                }
            }
            return quanhephapluat_name;
        }
        private void LoadReport_ST(decimal vDonID)
        {
            try
            {
                decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string vMaBC = "";
                if (Request["BM"] != null)
                    vMaBC = Request["BM"] + "";
                AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                List<AHC_SOTHAM_THULY> lstThuLy = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
                List<AHC_DON_THAMPHAN> lstGQD = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETDON).OrderByDescending(x => x.NGAYPHANCONG).ToList();

                List<AHC_DON_DUONGSU> lstND = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
                List<AHC_DON_DUONGSU> lstBD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                List<AHC_DON_DUONGSU> lstNVLQ = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();

                List<AHC_DON_DUONGSU> lstNDDD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();
                string strDiadiem = getDiaDiem((decimal)oDon.TOAANID);
                //Nguyên đơn đại diện
                string strND_Hoten = "", strND_Diachi = "", strND_Gioitinh = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "";
                string strTenQHPL = "";
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oDon.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("AHC", "DON", "", oDon.ID);
                if (lstNDDD.Count > 0)
                {
                    AHC_DON_DUONGSU oNDDD = lstNDDD[0];
                    strND_Hoten = oNDDD.TENDUONGSU;
                    if (oNDDD.LOAIDUONGSU == 1)
                    {
                        if (oNDDD.GIOITINH == 1)
                            strND_Gioitinh = "Ông";
                        else strND_Gioitinh = "Bà";
                        if (oNDDD.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNDDD.TAMTRUID);
                        strND_Diachi = oNDDD.TAMTRUCHITIET + " " + strND_Diachi;

                    }
                    else
                    {
                        if (oNDDD.NDD_DIACHIID != null) strND_Diachi = getDiachi((decimal)oNDDD.NDD_DIACHIID);
                        strND_Diachi = oNDDD.NDD_DIACHICHITIET + " " + strND_Diachi;
                    }
                    strND_Dienthoai = oNDDD.DIENTHOAI;
                    strND_Fax = oNDDD.FAX;
                    strND_Email = oNDDD.EMAIL;
                }
                if (vMaBC == "02-HC")
                {
                    idTitle.Text = "02-HC. Giấy xác nhận đã nhận đơn khởi kiện";
                    DTBIEUMAU objds = new DTBIEUMAU();
                    DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                    r.TENVUVIEC = strTenQHPL;
                    if (oDon.NGAYVIETDON != null)
                    {
                        DateTime oNgayViet = (DateTime)oDon.NGAYVIETDON;
                        r.NGAYVIETDON = oNgayViet.Day.ToString();
                        r.THANGVIETDON = oNgayViet.Month.ToString();
                        r.NAMVIETDON = oNgayViet.Year.ToString();
                    }
                    if (oDon.NGAYNHANDON != null)
                    {
                        DateTime oNgayViet = (DateTime)oDon.NGAYNHANDON;
                        r.NGAYNHANDON = oNgayViet.Day.ToString();
                        r.THANGNHANDON = oNgayViet.Month.ToString();
                        r.NAMNHANDON = oNgayViet.Year.ToString();
                    }
                    r.TENTOAAN = getTenToa((decimal)oDon.TOAANID);
                    r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                    r.TENNGUYENDON = strND_Hoten;
                    r.TENGIOITINH = strND_Gioitinh;
                    r.DIACHI = strND_Diachi;
                    r.EMAIL = strND_Email;
                    r.FAX = strND_Fax;
                    r.SODIENTHOAI = strND_Dienthoai;
                    r.DONID = oDon.ID.ToString();
                    r.DIADIEM = strDiadiem;
                    r.TENCHANHAN = getChanhAnByToaAn((decimal)oDon.TOAANID);
                    objds.DTBM30DS.AddDTBM30DSRow(r);
                    objds.AcceptChanges();
                    rpt02HC rpt = new rpt02HC();
                    rpt.DataSource = objds;
                    rptView.OpenReport(rpt);

                }
                else if (vMaBC == "03-HC")
                {
                    idTitle.Text = "03-HC. Thông báo trả lại đơn khởi kiện";
                    List<AHC_DON_XULY> lstCXL = dt.AHC_DON_XULY.Where(x => x.DONID == vDonID && x.LOAIGIAIQUYET == 3 && x.CDTN_TOAANID != DonViID).OrderByDescending(x => x.NGAYGQ_YC).ToList();
                    if (lstCXL.Count > 0)
                    {
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                        r.TENVUVIEC = strTenQHPL;
                        AHC_DON_XULY oCD = lstCXL[0];

                        string yearSTB;

                        if (oCD.NGAYTHONGBAO != null)
                        {
                            yearSTB = DateTime.Parse(Convert.ToString(oCD.NGAYTHONGBAO)).Year.ToString();
                        }
                        else
                        {
                            yearSTB = "...";
                        }

                        r.SOTHULY = oCD.SOTHONGBAO + oCD.STB_PHU + "/" + yearSTB + "/" + oCD.NGAYTHONGBAO +"";
                        if (oCD.TRADON_LYDOID != null)
                        {
                            try
                            {
                                DM_DATAITEM oLDTR = dt.DM_DATAITEM.Where(x => x.ID == oCD.TRADON_LYDOID).FirstOrDefault();
                                r.LYDOTRA = oLDTR.TEN;
                            }
                            catch { }
                        }

                        if (oCD.NGAYGQ_YC != null)
                        {
                            DateTime oNgayViet = (DateTime)oCD.NGAYGQ_YC;
                            r.NGAYGQ = oNgayViet.Day.ToString();
                            r.THANGGQ = oNgayViet.Month.ToString();
                            r.NAMGQ = oNgayViet.Year.ToString();
                        }
                        if (oDon.NGAYVIETDON != null)
                        {
                            DateTime oNgayViet = (DateTime)oDon.NGAYVIETDON;
                            r.NGAYVIETDON = oNgayViet.Day.ToString();
                            r.THANGVIETDON = oNgayViet.Month.ToString();
                            r.NAMVIETDON = oNgayViet.Year.ToString();
                        }
                        if (oDon.NGAYNHANDON != null)
                        {
                            DateTime oNgayViet = (DateTime)oDon.NGAYNHANDON;
                            r.NGAYNHANDON = oNgayViet.Day.ToString();
                            r.THANGNHANDON = oNgayViet.Month.ToString();
                            r.NAMNHANDON = oNgayViet.Year.ToString();
                        }

                        r.TENTOAAN = getTenToa((decimal)oDon.TOAANID);
                        r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                        r.TENNGUYENDON = strND_Hoten;
                        r.TENGIOITINH = strND_Gioitinh;
                        r.DIACHI = strND_Diachi;
                        r.EMAIL = strND_Email;
                        r.FAX = strND_Fax;
                        r.SODIENTHOAI = strND_Dienthoai;
                        r.DONID = oDon.ID.ToString();
                        r.DIADIEM = strDiadiem;
                        if (lstGQD.Count > 0)
                        {
                            r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                        }
                        objds.DTBM30DS.AddDTBM30DSRow(r);
                        objds.AcceptChanges();
                        rpt03HC rpt = new rpt03HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "04-HC")
                {
                    idTitle.Text = "04-HC. Thông báo nộp tiền tạm ứng án phí";        
                    List<AHC_ANPHI> lstAP = dt.AHC_ANPHI.Where(x => x.DONID == vDonID && x.TAMUNGANPHI > 0).ToList();
                    if (lstAP.Count > 0)
                    {
                        DTBIEUMAU objds = new DTBIEUMAU();
                        foreach (AHC_ANPHI oAP in lstAP)
                        {
                            string[] lstDS = oAP.DUONGSU_IDS.Split(',');
                            decimal dsID = Convert.ToDecimal(lstDS[0]);
                            AHC_DON_DUONGSU oNG = dt.AHC_DON_DUONGSU.Where(x => x.ID == dsID).FirstOrDefault();
                            string tenDS = oNG.TENDUONGSU;
                            if (lstDS.Count() > 1)
                            {
                                tenDS = "";
                                foreach (string ds in lstDS)
                                {
                                    dsID = Convert.ToDecimal(ds);
                                    AHC_DON_DUONGSU oDS = dt.AHC_DON_DUONGSU.Where(x => x.ID == dsID).FirstOrDefault();
                                    tenDS += oDS.TENDUONGSU + ", ";
                                }
                                tenDS = tenDS.Remove(tenDS.Length - 2);
                            }
                            
                            if (oNG != null)
                            {
                                DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                                r.TENVUVIEC = strTenQHPL;
                                r.TAMUNGANPHI = ((decimal)oAP.TAMUNGANPHI).ToString("#,#", cul);
                                r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN((decimal)oAP.TAMUNGANPHI);
                                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                                String _TOAANID = Convert.ToString(oDon.TOAANID);
                                DM_TOAAN_THIHANHAN_MAP oThaid = dt.DM_TOAAN_THIHANHAN_MAP.Where(x => x.TOAANID == oDon.TOAANID).FirstOrDefault();
                                decimal _oThaid = Convert.ToDecimal(oThaid.THIHANHANID);
                                DM_DONVITHIHANHAN oTHADS = dt.DM_DONVITHIHANHAN.Where(x => x.ID == _oThaid).FirstOrDefault();
                                if (oTA != null)
                                {
                                    r.TENTOAAN = getTenToa(oTA.ID);
                                    r.TENCQTHA = oTHADS.MA_TEN;
                                    r.DIACHICQTHA = oTHADS.DIACHI;
                                }
                                r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                                r.TENNGUYENDON = tenDS;
                                if (oNG.LOAIDUONGSU == 1)
                                {                                 
                                    if (oNG.GIOITINH == 1)
                                        strND_Gioitinh = "Ông";
                                    else
                                        strND_Gioitinh = "Bà";

                                    if (lstDS.Count() > 1)
                                        strND_Gioitinh = "Các ông/bà ";

                                    if (strND_Gioitinh == "Các ông/bà ")
                                    {
                                        AHC_DON_DUONGSU oNGHN = dt.AHC_DON_DUONGSU.Where(x => x.DONID == oAP.DONID && x.ISDAIDIEN == 1 && x.TUCACHTOTUNG_MA == "NGUYENDON").FirstOrDefault();
                                        if (oNGHN.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNGHN.TAMTRUID);
                                        if (oNGHN.TAMTRUCHITIET != null) strND_Diachi = oNGHN.TAMTRUCHITIET + ", " + strND_Diachi;
                                    }
                                    else
                                    {
                                        if (oNG.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNG.TAMTRUID);
                                        if (oNG.TAMTRUCHITIET != null) strND_Diachi = oNG.TAMTRUCHITIET + ", " + strND_Diachi;
                                    }
                                }
                                else
                                {
                                    if (oNG.NDD_DIACHIID != null) strND_Diachi = getDiachi((decimal)oNG.NDD_DIACHIID);
                                    if (oNG.NDD_DIACHICHITIET != null) strND_Diachi = oNG.NDD_DIACHICHITIET + ", " + strND_Diachi;
                                }

                                r.TENGIOITINH = strND_Gioitinh;
                                r.DIACHI = strND_Diachi;
                                r.EMAIL = oNG.EMAIL;
                                r.FAX = oNG.FAX;
                                r.SODIENTHOAI = strND_Dienthoai;
                                r.DONID = oDon.ID.ToString() + oNG.ID.ToString();
                                r.DIADIEM = strDiadiem;
                                r.SOTHONGBAO = oAP.SOTHONGBAO;
                                if (oAP.NGAYTHONGBAO != null)
                                {
                                    DateTime oNgayGQ = (DateTime)oAP.NGAYTHONGBAO;
                                    r.NGAYGQ = oNgayGQ.Day.ToString();
                                    r.THANGGQ = oNgayGQ.Month.ToString();
                                    r.NAMGQ = oNgayGQ.Year.ToString();
                                }
                                r.DONID = oAP.ID.ToString();
                                String V_MA_THONGBAO;
                                DVCQG_THANH_TOAN_BL oBL = new DVCQG_THANH_TOAN_BL();
                                V_MA_THONGBAO = oBL.DVCQG_THANH_TOAN_SEARCH(2, vDonID, oAP.ID, "6").ToString();
                                r.MAVUVIEC = V_MA_THONGBAO;                                
                                if (lstGQD.Count > 0)
                                {
                                    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                                }
                                objds.DTBM30DS.AddDTBM30DSRow(r);
                                objds.AcceptChanges();
                            }
                        }
                        rpt04HC rpt = new rpt04HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);

                        //DTBIEUMAU objds = new DTBIEUMAU();
                        //DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                        //r.TENVUVIEC = strTenQHPL;
                        //AHC_ANPHI oAP = lstAP[0];
                        //r.TAMUNGANPHI = ((decimal)oAP.TAMUNGANPHI).ToString("#,#", cul);
                        //r.TAMUNGBANGCHU = Cls_Comon.NumberToTextVN((decimal)oAP.TAMUNGANPHI);
                        //r.TENTOAAN = getTenToa((decimal)oDon.TOAANID);
                        //r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                        //r.TENNGUYENDON = strND_Hoten;
                        //r.TENGIOITINH = strND_Gioitinh;
                        //r.DIACHI = strND_Diachi;
                        //r.EMAIL = strND_Email;
                        //r.FAX = strND_Fax;
                        //r.SODIENTHOAI = strND_Dienthoai;
                        //r.DONID = oDon.ID.ToString();
                        //r.DIADIEM = strDiadiem;
                        //if (lstGQD.Count > 0)
                        //{
                        //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                        //}
                        //objds.DTBM30DS.AddDTBM30DSRow(r);
                        //objds.AcceptChanges();
                        //rpt04HC rpt = new rpt04HC();
                        //rpt.DataSource = objds;
                        //rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "06-HC")
                {
                    idTitle.Text = "06-HC. Thông báo về việc thụ lý vụ án";
                    if (lstThuLy.Count > 0)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                        r.TENVUVIEC = strTenQHPL;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                        if (lstGQD.Count > 0)
                        {
                            r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                        }
                        r.TENNGUYENDON = strND_Hoten;
                        r.TENGIOITINH = strND_Gioitinh;
                        r.DIACHI = strND_Diachi;
                        r.EMAIL = strND_Email;
                        r.FAX = strND_Fax;
                        r.SODIENTHOAI = strND_Dienthoai;
                        r.DONID = oDon.ID.ToString();
                        r.DIADIEM = strDiadiem;
                        objds.DTBM30DS.AddDTBM30DSRow(r);
                        objds.AcceptChanges();
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //CÁc tài liệu
                        List<AHC_DON_TAILIEU> lstTailieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYBANGIAO).ToList();
                        foreach (AHC_DON_TAILIEU ods in lstTailieu)
                        {
                            DTBIEUMAU.DTTAILIEURow nd = objds.DTTAILIEU.NewDTTAILIEURow();
                            nd.DONID = oDon.ID.ToString();
                            nd.ID = ods.ID.ToString();
                            nd.TENTAILIEU = ods.TENTAILIEU;
                            objds.DTTAILIEU.AddDTTAILIEURow(nd);
                            objds.AcceptChanges();
                        }
                        rpt06HC rpt = new rpt06HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "09-HC")
                {
                    idTitle.Text = "09-HC. Quyết định công nhận kết quả đối thoại thành, đình chỉ giải quyết vụ án";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "09-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.DONID = oDon.ID.ToString();
                        if (lstGQD.Count > 0)
                        {
                            r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                        }
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.DIADIEM = strDiadiem;
                        objds.DTBM30DS.AddDTBM30DSRow(r);
                        objds.AcceptChanges();
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        rpt09HC rpt = new rpt09HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "10-HC")// Giống 41-DS
                {
                    idTitle.Text = "10-HC. Quyết định tạm đình chỉ giải quyết vụ án hành chính (dành cho Thẩm phán)";
                    //Kiểm tra xem đã có quyết định hay không
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "10-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.DIADIEM = strDiadiem;
                        if (oQD.HIEULUCTU != null)
                        {
                            DateTime oNgayHL = (DateTime)oQD.HIEULUCTU;
                            r.NGAYHIEULUC = oNgayHL.Day.ToString();
                            r.THANGHIEULUC = oNgayHL.Month.ToString();
                            r.NAMHIEULUC = oNgayHL.Year.ToString();
                        }
                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDOTAMDINHCHI = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDOTAMDINHCHI = lstQDLD[lstQDLD.Count - 1].TEN;
                        }


                        //Hội đồng xét xử
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        objds.AcceptChanges();
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        rpt10HC rpt = new rpt10HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "11-HC")//Giống 42-DS
                {
                    idTitle.Text = "11-HC. Quyết định tạm đình chỉ giải quyết vụ án hành chính (dành cho Hội đồng xét xử)";
                    //Kiểm tra xem đã có quyết định hay không
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "11-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.HIEULUCTU != null)
                        {
                            DateTime oNgayHL = (DateTime)oQD.HIEULUCTU;
                            r.NGAYHIEULUC = oNgayHL.Day.ToString();
                            r.THANGHIEULUC = oNgayHL.Month.ToString();
                            r.NAMHIEULUC = oNgayHL.Year.ToString();
                        }
                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDOTAMDINHCHI = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDOTAMDINHCHI = lstQDLD[lstQDLD.Count - 1].TEN;
                        }

                        //Hội đồng xét xử                       
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        rpt11HC rpt = new rpt11HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "12-HC")//Giống 43-DS
                {
                    idTitle.Text = "12-HC. Quyết định tiếp tục giải quyết vụ án hành chính (dành cho Thẩm phán) ";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TTGQ").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "12-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.HIEULUCTU != null)
                        {
                            DateTime oNgayHL = (DateTime)oQD.HIEULUCTU;
                            r.NGAYHIEULUC = oNgayHL.Day.ToString();
                            r.THANGHIEULUC = oNgayHL.Month.ToString();
                            r.NAMHIEULUC = oNgayHL.Year.ToString();
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDOTAMDINHCHI = lstQDLD[0].TEN;
                        }
                        //Lấy quyết định tđc
                        DM_QD_LOAI oTDCQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                        List<AHC_SOTHAM_QUYETDINH> lstQDTDC = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == oTDCQD.ID && x.NGAYQD <= oQD.NGAYQD).OrderByDescending(x => x.NGAYQD).ToList();
                        if (lstQDTDC.Count > 0)
                        {
                            DateTime oNgayTDC = (DateTime)lstQDTDC[0].NGAYQD;
                            r.TDCNGAY = oNgayTDC.Day.ToString();
                            r.TDCTHANG = oNgayTDC.Month.ToString();
                            r.TDCNAM = oNgayTDC.Year.ToString();
                            r.TDCSO = lstQDTDC[0].SOQD;
                        }
                        //Hội đồng xét xử
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        objds.AcceptChanges();
                        rpt12HC rpt = new rpt12HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "13-HC")//Giống 44-DS
                {
                    idTitle.Text = "13-HC. Quyết định tiếp tục giải quyết vụ án hành chính (dành cho Hội đồng xét xử)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TTGQ").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "13-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.HIEULUCTU != null)
                        {
                            DateTime oNgayHL = (DateTime)oQD.HIEULUCTU;
                            r.NGAYHIEULUC = oNgayHL.Day.ToString();
                            r.THANGHIEULUC = oNgayHL.Month.ToString();
                            r.NAMHIEULUC = oNgayHL.Year.ToString();
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDOTAMDINHCHI = lstQDLD[0].TEN;
                        }
                        //Lấy quyết định tđc
                        DM_QD_LOAI oTDCQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                        List<AHC_SOTHAM_QUYETDINH> lstQDTDC = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == oTDCQD.ID && x.NGAYQD <= oQD.NGAYQD).OrderByDescending(x => x.NGAYQD).ToList();
                        if (lstQDTDC.Count > 0)
                        {
                            DateTime oNgayTDC = (DateTime)lstQDTDC[0].NGAYQD;
                            r.TDCNGAY = oNgayTDC.Day.ToString();
                            r.TDCTHANG = oNgayTDC.Month.ToString();
                            r.TDCNAM = oNgayTDC.Year.ToString();
                            r.TDCSO = lstQDTDC[0].SOQD;
                        }
                        //Hội đồng xét xử                       
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);

                        rpt13HC rpt = new rpt13HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "14-HC")// Giống 45-DS
                {
                    idTitle.Text = "14-HC. Quyết định đình chỉ giải quyết vụ án hành chính (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "14-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();

                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDOTAMDINHCHI = lstQDLD[0].TEN;
                        }
                        //Hội đồng xét xử
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        objds.AcceptChanges();
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);

                        rpt14HC rpt = new rpt14HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "15-HC")// Giống 46-DS
                {
                    idTitle.Text = "15-HC. Quyết định đình chỉ giải quyết vụ án dân sự (dành cho Hội đồng xét xử)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "15-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM41DSRow r = objds.DTBM41DS.NewDTBM41DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDOTAMDINHCHI = lstQDLD[0].TEN;
                        }
                        //Hội đồng xét xử                       
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        objds.DTBM41DS.AddDTBM41DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);

                        rpt15HC rpt = new rpt15HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "16-HC")// giống 47-DS
                {
                    idTitle.Text = "16-HC. Quyết định đưa vụ án ra xét xử";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "16-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM47DSRow r = objds.DTBM47DS.NewDTBM47DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        //Hội đồng xét xử
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        r.THAMPHANDUKHUYET = GetThamPhanDuKhuyet(lstHDXX);
                        r.THUKYPHIENTOA = GetThuKy(lstHDXX);
                        objds.DTBM47DS.AddDTBM47DSRow(r);
                        objds.AcceptChanges();
                        //KSV
                        objds = FillDSKiemSatVien(objds, lstHDXX);
                        //Người TGTT
                        AHC_DON_BL oBL = new AHC_DON_BL();
                        DataTable dsNguoiTGTT = oBL.AHC_DON_TGTT_GETLIST(vDonID);
                        objds = FillDSNguoiTGTT(objds, dsNguoiTGTT);
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);

                        rpt16HC rpt = new rpt16HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "17-HC")// giống 16-HC
                {
                    idTitle.Text = "17-HC. Quyết định đưa vụ án ra giải quyết sơ thẩm theo thủ tục rút gọn";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "17-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM47DSRow r = objds.DTBM47DS.NewDTBM47DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKHOIKIEN = strND_Gioitinh + " " + strND_Hoten;
                        r.DIACHI = strND_Diachi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        //Hội đồng xét xử
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        r.THAMPHANDUKHUYET = GetThamPhanDuKhuyet(lstHDXX);
                        r.THUKYPHIENTOA = GetThuKy(lstHDXX);
                        objds.DTBM47DS.AddDTBM47DSRow(r);
                        objds.AcceptChanges();
                        //KSV
                        objds = FillDSKiemSatVien(objds, lstHDXX);
                        //Người TGTT
                        AHC_DON_BL oBL = new AHC_DON_BL();
                        DataTable dsNguoiTGTT = oBL.AHC_DON_TGTT_GETLIST(vDonID);
                        objds = FillDSNguoiTGTT(objds, dsNguoiTGTT);
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);
                        //Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);

                        rpt17HC rpt = new rpt17HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "18-HC")// giống 49-DS
                {
                    idTitle.Text = "18-HC. Quyết định hoãn phiên toà";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "HPT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "18-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM47DSRow r = objds.DTBM47DS.NewDTBM47DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();

                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDO = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDO = lstQDLD[lstQDLD.Count - 1].TEN;
                        }


                        // Lấy Quyết định đưa vụ án ra xét xử
                        decimal IDLQDDVAXX = 0;
                        DM_QD_LOAI oLQDRXX = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                        if (oLQDRXX != null) IDLQDDVAXX = oLQDRXX.ID;
                        AHC_SOTHAM_QUYETDINH QDRXX = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDDVAXX).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
                        if (QDRXX != null)
                        {
                            r.DVAXXSO = QDRXX.SOQD;
                            DateTime oNgayRXX = (DateTime)QDRXX.NGAYQD;
                            r.DVAXXNGAY = oNgayRXX.Day.ToString();
                            r.DVAXXTHANG = oNgayRXX.Month.ToString();
                            r.DVAXXNAM = oNgayRXX.Year.ToString();
                        }
                        //Hội đồng xét xử                       
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        r.THUKYPHIENTOA = GetThuKy(lstHDXX);
                        objds.DTBM47DS.AddDTBM47DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Kiểm sát viên
                        objds = FillDSKiemSatVien(objds, lstHDXX);
                        //Hội thẩm
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);

                        rpt18HC rpt = new rpt18HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "19-HC")// giống 50-DS
                {
                    idTitle.Text = "19-HC. Quyết định tạm ngừng phiên toà";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TNPT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "19-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM47DSRow r = objds.DTBM47DS.NewDTBM47DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDO = lstQDLD[0].TEN;
                        }
                        // Lấy Quyết định đưa vụ án ra xét xử
                        decimal IDLQDDVAXX = 0;
                        DM_QD_LOAI oLQDRXX = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                        if (oLQDRXX != null) IDLQDDVAXX = oLQDRXX.ID;
                        AHC_SOTHAM_QUYETDINH QDRXX = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDDVAXX).OrderByDescending(x => x.NGAYQD).FirstOrDefault();
                        if (QDRXX != null)
                        {
                            r.DVAXXSO = QDRXX.SOQD;
                            DateTime oNgayRXX = (DateTime)QDRXX.NGAYQD;
                            r.DVAXXNGAY = oNgayRXX.Day.ToString();
                            r.DVAXXTHANG = oNgayRXX.Month.ToString();
                            r.DVAXXNAM = oNgayRXX.Year.ToString();
                        }
                        //Hội đồng xét xử                       
                        List<AHC_SOTHAM_HDXX> lstHDXX = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHDXX);
                        objds.DTBM47DS.AddDTBM47DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHDXX);
                        //Hội thẩm
                        objds = FillDSHoiThamNhanDan(objds, lstHDXX);

                        rpt19HC rpt = new rpt19HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                
                else if (vMaBC == "32-HC")
                {
                    //Thông tin bản án/Quyết định kháng cáo, kháng nghị
                    //string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTAO).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTAO).ToList();

                    idTitle.Text = "32-HC. Thông báo về việc kháng cáo";
                    if (lstThuLy.Count > 0)
                    {
                        DTBIEUMAU objds = new DTBIEUMAU();
                        List<AHC_DON_DUONGSU> lstNG = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID).OrderByDescending(x => x.ISDAIDIEN).ToList();
                        List<AHC_DON_TAILIEU> lstTailieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYBANGIAO).ToList();
                        int i = 0; int z = 0;
                        if (lstkc.Count > 0)
                        {
                            foreach (AHC_SOTHAM_KHANGCAO oKC in lstkc)
                            {
                                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                                AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                                AHC_DON_DUONGSU oNG = lstNG[z];
                                z++;
                                //strTenQHPL = getQuanhephapluat_name("AHN", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));
                                if (lstTailieu.Count > 0)
                                {
                                    AHC_DON_TAILIEU oTL = lstTailieu[i];
                                    r.TENTAILIEU = oTL.TENTAILIEU;
                                    i++;
                                }
                                r.NOIDUNGKHANGCAO = oKC.NOIDUNGKHANGCAO;

                                if (oNG.TAMTRUID != null) { r.DIACHINHAN = getDiachi((decimal)oNG.TAMTRUID); }
                                r.DIACHINHAN = oNG.TAMTRUCHITIET + " " + r.DIACHINHAN;
                                r.NGUOIKHANGCAO = oNG.TENDUONGSU;
                                r.DIADIEM = strDiadiem;
                                r.SOTHULY = oSTTL.SOTHULY;
                                // ngày kháng cáo
                                DateTime oNgayTL = (DateTime)oKC.NGAYKHANGCAO;
                                r.NGAYTHULY = oNgayTL.Day.ToString();
                                r.THANGTHULY = oNgayTL.Month.ToString();
                                r.NAMTHULY = oNgayTL.Year.ToString();
                                r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                                r.STTENTOAAN = getTenToa((decimal)oKC.TOAANRAQDID);
                                if (lstGQD.Count > 0)
                                {
                                    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                                }
                                decimal BAKCID = (decimal)oKC.SOQDBA;
                                List<AHC_SOTHAM_QUYETDINH> lstKCBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                                if (lstKCBA.Count > 0)
                                {
                                    r.STSOBAQD = lstKCBA[0].SOQD;
                                }
                                // ngày quyết định bản án
                                DateTime oNgayBAQD = (DateTime)oKC.NGAYQDBA;
                                r.STNGAYBAQD = oNgayBAQD.Day.ToString();
                                r.STTHANGBAQD = oNgayBAQD.Month.ToString();
                                r.STNAMBAQD = oNgayBAQD.Year.ToString();
                                objds.DTBM65DS.AddDTBM65DSRow(r);
                                objds.AcceptChanges();
                            }
                        }
                        if (lstkn.Count > 0)
                        {
                            foreach (AHC_SOTHAM_KHANGNGHI oKN in lstkn)
                            {
                                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                                AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                                AHC_DON_DUONGSU oNG = lstNG[z];
                                z++;
                                //strTenQHPL = getQuanhephapluat_name("AHN", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));
                                if (lstTailieu.Count > 0)
                                {
                                    AHC_DON_TAILIEU oTL = lstTailieu[i];
                                    r.TENTAILIEU = oTL.TENTAILIEU;
                                    i++;
                                }
                                r.NOIDUNGKHANGCAO = oKN.NOIDUNGKN;
                                if (oNG.TAMTRUID != null) { r.DIACHINHAN = getDiachi((decimal)oNG.TAMTRUID); }
                                r.DIACHINHAN = oNG.TAMTRUCHITIET + " " + r.DIACHINHAN;
                                r.NGUOIKHANGCAO = oNG.TENDUONGSU;
                                r.DIADIEM = strDiadiem;
                                //ngày kháng nghị
                                DateTime oNgayTL = (DateTime)oKN.NGAYKN;
                                r.NGAYTHULY = oNgayTL.Day.ToString();
                                r.THANGTHULY = oNgayTL.Month.ToString();
                                r.NAMTHULY = oNgayTL.Year.ToString();
                                r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                                r.STTENTOAAN = getTenToa((decimal)oKN.TOAANRAQDID);
                                if (lstGQD.Count > 0)
                                {
                                    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                                }
                                //lấy từ cột QDBA AHN_KCKN
                                List<AHC_SOTHAM_QUYETDINH> lstKCBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
                                if (lstKCBA.Count > 0)
                                {
                                    r.STSOBAQD = lstKCBA[0].SOQD;
                                }
                                //ngày quyết định bản án
                                DateTime oNgayBAQD = (DateTime)oKN.NGAYBANAN;
                                r.STNGAYBAQD = oNgayBAQD.Day.ToString();
                                r.STTHANGBAQD = oNgayBAQD.Month.ToString();
                                r.STNAMBAQD = oNgayBAQD.Year.ToString();
                                objds.DTBM65DS.AddDTBM65DSRow(r);
                                objds.AcceptChanges();
                            }
                        }
                        rpt62DS rpt = new rpt62DS();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "57-HC")
                {
                    idTitle.Text = "57-HC. Quyết định áp dụng biện pháp khẩn cấp tạm thời (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "57-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();

                        rpt57HC rpt = new rpt57HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "58-HC")
                {
                    idTitle.Text = "58-HC. Quyết định áp dụng biện pháp khẩn cấp tạm thời (dành cho Hội đồng xét xử sơ thẩm)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "58-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.GIAIDOAN = "sơ thẩm";
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHD);
                        // Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHD);
                        rpt58HC rpt = new rpt58HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "59-HC")
                {
                    idTitle.Text = "59-HC. Quyết định thay đổi biện pháp khẩn cấp tạm thời (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0, IDLQDKCTT = 0, IDQDKCTT = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "59-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    // Lấy ra quyết định áp dụng BPKCTT
                    DM_QD_LOAI oLQDKCTT = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQDKCTT != null) IDLQDKCTT = oLQDKCTT.ID;
                    DM_QD_QUYETDINH oDMQDKCTT = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQDKCTT && x.MA == "57-HC").FirstOrDefault();
                    IDQDKCTT = oDMQDKCTT.ID;
                    AHC_SOTHAM_QUYETDINH oQDKCTT = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDKCTT && x.QUYETDINHID == IDQDKCTT).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        // Biện pháp KCTT bị thay đổi
                        if (oQDKCTT != null)
                        {
                            r.SOQD_THAYDOI = oQDKCTT.SOQD;
                            DateTime oNgayQD_THAYDOI = (DateTime)oQDKCTT.NGAYQD;
                            r.NGAYQD_THAYDOI = oNgayQD_THAYDOI.Day.ToString();
                            r.THANGQD_THAYDOI = oNgayQD_THAYDOI.Month.ToString();
                            r.NAMQD_THAYDOI = oNgayQD_THAYDOI.Year.ToString();
                            r.NOIDUNGYC_THAYDOI = oQDKCTT.GHICHU;
                        }
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();

                        rpt59HC rpt = new rpt59HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "60-HC")
                {
                    idTitle.Text = "60-HC. Quyết định thay đổi biện pháp khẩn cấp tạm thời (dành cho Hội đồng xét xử sơ thẩm)";
                    decimal IDLQD = 0, IDQD = 0, IDLQDKCTT = 0, IDQDKCTT = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "60-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_SOTHAM_QUYETDINH oQD = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    // Lấy ra quyết định áp dụng BPKCTT
                    DM_QD_LOAI oLQDKCTT = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQDKCTT != null) IDLQDKCTT = oLQDKCTT.ID;
                    DM_QD_QUYETDINH oDMQDKCTT = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQDKCTT && x.MA == "57-HC").FirstOrDefault();
                    IDQDKCTT = oDMQDKCTT.ID;
                    AHC_SOTHAM_QUYETDINH oQDKCTT = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDKCTT && x.QUYETDINHID == IDQDKCTT).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_SOTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPLL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPLL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.GIAIDOAN = "sơ thẩm";
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_SOTHAM_HDXX> lstHD = dt.AHC_SOTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToa(lstHD);
                        // Biện pháp KCTT bị thay đổi
                        if (oQDKCTT != null)
                        {
                            r.SOQD_THAYDOI = oQDKCTT.SOQD;
                            DateTime oNgayQD_THAYDOI = (DateTime)oQDKCTT.NGAYQD;
                            r.NGAYQD_THAYDOI = oNgayQD_THAYDOI.Day.ToString();
                            r.THANGQD_THAYDOI = oNgayQD_THAYDOI.Month.ToString();
                            r.NAMQD_THAYDOI = oNgayQD_THAYDOI.Year.ToString();
                            r.NOIDUNGYC_THAYDOI = oQDKCTT.GHICHU;
                        }
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVien(objds, lstHD);
                        // Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDan(objds, lstHD);

                        rpt60HC rpt = new rpt60HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        private void LoadReport_PT(decimal vDonID)
        {
            try
            {
                AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
                decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                string vMaBC = "";
                if (Request["BM"] != null)
                    vMaBC = Request["BM"] + "";
                List<AHC_PHUCTHAM_THULY> lstThuLy = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
                List<AHC_DON_THAMPHAN> lstGQD = dt.AHC_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
                List<AHC_DON_DUONGSU> lstND = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
                List<AHC_DON_DUONGSU> lstBD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
                List<AHC_DON_DUONGSU> lstNVLQ = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
                List<AHC_DON_DUONGSU> lstNDDD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();
                //Nguyên đơn đại diện
                string strND_Hoten = "", strND_Diachi = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "", strTenQHPL = "";
                if (lstNDDD.Count > 0)
                {
                    AHC_DON_DUONGSU oNDDD = lstNDDD[0];
                    strND_Hoten = oNDDD.TENDUONGSU;
                    if (oNDDD.LOAIDUONGSU == 1)
                    {
                        if (oNDDD.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNDDD.TAMTRUID);
                        strND_Diachi = oNDDD.TAMTRUCHITIET + " " + strND_Diachi;
                    }
                    else
                    {
                        if (oNDDD.NDD_DIACHIID != null) strND_Diachi = getDiachi((decimal)oNDDD.NDD_DIACHIID);
                        strND_Diachi = oNDDD.NDD_DIACHICHITIET + " " + strND_Diachi;
                    }
                    strND_Dienthoai = oNDDD.DIENTHOAI;
                    strND_Fax = oNDDD.FAX;
                    strND_Email = oNDDD.EMAIL;
                }
                if (vMaBC == "35-HC")// giống 65-DS
                {
                    //Thông tin bản án/Quyết định kháng cáo, kháng nghị
                    string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
                    string nameKCKN = "";
                    if (lstkn.Count > 0)
                    {
                        nameKCKN = "quyết định kháng nghị";
                        //lstkn[0].BANANID
                        AHC_SOTHAM_KHANGNGHI oKN = lstkn[0];

                        string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                        strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-HC ngày " + ngayKN;

                        strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                        if (oKN.DONVIKN == 1)
                        {
                            strKC_Nguoi = "Viện trưởng";
                            if (oKN.CAPKN == 0)
                                strKC_Nguoi = strKC_Nguoi + " " + strKC_Toaan.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân").Replace("TAND", "Viện kiểm sát nhân dân");
                            else
                               if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getVKS((decimal)oKN.TOAAN_VKS_KN);
                        }
                        else
                        {
                            strKC_Nguoi = "Chánh án";
                            if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getTenToa((decimal)oKN.TOAAN_VKS_KN);
                        }
                        strLoaiKCKN += " của " + strKC_Nguoi;
                        strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-HC ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                        if (oKN.LOAIKN == 0)//BẢn án
                        {
                            strLoaiBAQD = "bản án";
                            List<AHC_SOTHAM_BANAN> lstKNBA = dt.AHC_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
                            if (lstKNBA.Count > 0)
                            {
                                strKC_SOBAQD = lstKNBA[0].SOBANAN;
                                DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYTUYENAN;
                                strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                                strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                                strKC_NamBAQD = oNgayBAQD.Year.ToString();
                            }
                        }
                        else
                        {
                            strLoaiBAQD = "quyết định";
                            List<AHC_SOTHAM_QUYETDINH> lstKNBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
                            if (lstKNBA.Count > 0)
                            {
                                strKC_SOBAQD = lstKNBA[0].SOQD;
                                DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                                strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                                strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                                strKC_NamBAQD = oNgayBAQD.Year.ToString();
                            }
                        }
                    }
                    if (lstkc.Count > 0) //Kháng cáo
                    {
                        if (lstkn.Count > 0)
                        {
                            strLoaiKCKN += " và ";
                            nameKCKN += " và ";
                        }
                        nameKCKN += "đơn kháng cáo";
                        strLoaiKCKN += "đơn kháng cáo";
                        AHC_SOTHAM_KHANGCAO oKN = lstkc[0];

                        strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                        if (oKN.DUONGSUID != null)
                        {
                            List<AHC_DON_DUONGSU> lstDSKC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
                            if (lstDSKC.Count > 0)
                            {
                                strKC_Nguoi = lstDSKC[0].TENDUONGSU;
                                if (lstDSKC[0].LOAIDUONGSU == 1)
                                {
                                    if (lstDSKC[0].GIOITINH == 1)
                                        strKC_Nguoi = "ông " + strKC_Nguoi;
                                    else strKC_Nguoi = "bà " + strKC_Nguoi;
                                }
                                if (lstDSKC[0].TAMTRUID != null) strKC_Diachi = getDiachi((decimal)lstDSKC[0].TAMTRUID);
                                strKC_Diachi = "địa chỉ: " + lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                                if (strKC_Diachi.Trim() != "")
                                {
                                    strKC_Diachi = "địa chỉ: " + strKC_Diachi + ", ";
                                }
                            }
                        }
                        if (lstkn.Count > 0)
                        {
                            strKC_Diachi += "kháng nghị";
                            strKC_Diachi += ", kháng cáo";
                        }
                        else
                        {
                            strKC_Diachi += "kháng cáo";
                        }

                        strLoaiKCKN += " của " + strKC_Nguoi;
                        if (lstkn.Count > 0)
                        {
                            strKC_Noidung += ", ";
                        }
                        strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                        if (oKN.LOAIKHANGCAO == 0)//BẢn án
                        {
                            strLoaiBAQD = "Bản án hành chính";
                            decimal BAKCID = (decimal)oKN.SOQDBA;
                            List<AHC_SOTHAM_BANAN> lstKNBA = dt.AHC_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
                            if (lstKNBA.Count > 0)
                            {
                                strKC_SOBAQD = lstKNBA[0].SOBANAN;
                                DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYTUYENAN;
                                strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                                strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                                strKC_NamBAQD = oNgayBAQD.Year.ToString();
                            }
                        }
                        else
                        {
                            strLoaiBAQD = "quyết định";
                            decimal BAKCID = (decimal)oKN.SOQDBA;
                            List<AHC_SOTHAM_QUYETDINH> lstKNBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                            if (lstKNBA.Count > 0)
                            {
                                strKC_SOBAQD = lstKNBA[0].SOQD;
                                DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                                strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                                strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                                strKC_NamBAQD = oNgayBAQD.Year.ToString();
                            }
                        }
                    }
                    idTitle.Text = "35-HC. Thông báo về việc thụ lý vụ án để xét xử phúc thẩm";
                    if (lstThuLy.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                        r.DIADIEM = strDiadiem;
                        r.LOAIKCKN = strLoaiKCKN;
                        r.LOAIBQQD = strLoaiBAQD;
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = String.Format("{0:dd}", oNgayTL);
                        r.THANGTHULY = String.Format("{0:MM}", oNgayTL);
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.SOTHONGBAO = oSTTL.SOTHONGBAO;
                        DateTime oNgayTB = (DateTime)oSTTL.NGAYTHONGBAO;
                        r.NGAYTHONGBAO = String.Format("{0:dd}", oNgayTB);
                        r.THANGTHONGBAO = String.Format("{0:MM}", oNgayTB);
                        r.NAMTHONGBAO = oNgayTB.Year.ToString();
                        DM_VKS vks = dt.DM_VKS.Where(x => x.TOAANID == oSTTL.TOAANID).FirstOrDefault();
                        if (vks != null)
                        {
                            r.NGUOINHAN1 = vks.TEN;
                        }
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        if (lstGQD.Count > 0)
                        {
                            r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                        }
                        else
                        {
                            r.TENTHAMPHAN = "";
                        }

                        AHC_DON_DUONGSU ND = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                        AHC_DON_DUONGSU BD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                        string strND = "", strBD = "";

                        if (ND.LOAIDUONGSU == 1)
                        {
                            if (ND.GIOITINH == 0)
                            {
                                if (ND.TAMTRUCHITIET != null || ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (ND.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + ND.TAMTRUCHITIET;
                                    }
                                    if (ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)ND.TAMTRUID);
                                    }
                                    strND += "Bà " + ND.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strND += "Bà " + ND.TENDUONGSU + ".";
                                }
                            }
                            else
                            {
                                if (ND.TAMTRUCHITIET != null || ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (ND.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + ND.TAMTRUCHITIET;
                                    }
                                    if (ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)ND.TAMTRUID);
                                    }
                                    strND += "Ông " + ND.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strND += "Ông " + ND.TENDUONGSU + ".";
                                }
                            }
                        }
                        else
                        {
                            if (ND.GIOITINH == 0)
                            {
                                if (ND.TAMTRUCHITIET != null || ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (ND.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + ND.TAMTRUCHITIET;
                                    }
                                    if (ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)ND.TAMTRUID);
                                    }
                                    strND += ND.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strND += ND.TENDUONGSU + ".";
                                }
                            }
                            else
                            {
                                if (ND.TAMTRUCHITIET != null || ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (ND.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + ND.TAMTRUCHITIET;
                                    }
                                    if (ND.TAMTRUID != 0 && ND.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)ND.TAMTRUID);
                                    }
                                    strND += ND.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strND += ND.TENDUONGSU + ".";
                                }
                            }
                        }

                        if (BD.LOAIDUONGSU == 1)
                        {
                            if (BD.GIOITINH == 0)
                            {
                                if (BD.TAMTRUCHITIET != null || BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (BD.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + BD.TAMTRUCHITIET;
                                    }
                                    if (BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)BD.TAMTRUID);
                                    }
                                    strBD += "Bà " + BD.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strBD += "Bà " + BD.TENDUONGSU + ".";
                                }
                            }
                            else
                            {
                                if (BD.TAMTRUCHITIET != null || BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (BD.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + BD.TAMTRUCHITIET;
                                    }
                                    if (BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)BD.TAMTRUID);
                                    }
                                    strBD += "Ông " + BD.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strBD += "Ông " + BD.TENDUONGSU + ".";
                                }
                            }
                        }
                        else
                        {
                            if (BD.GIOITINH == 0)
                            {
                                if (BD.TAMTRUCHITIET != null || BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (BD.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + BD.TAMTRUCHITIET;
                                    }
                                    if (BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)BD.TAMTRUID);
                                    }
                                    strBD += BD.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strBD += BD.TENDUONGSU + ".";
                                }
                            }
                            else
                            {
                                if (BD.TAMTRUCHITIET != null || BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                {
                                    string strADRESS = ", địa chỉ:";
                                    if (BD.TAMTRUCHITIET != null)
                                    {
                                        strADRESS += " " + BD.TAMTRUCHITIET;
                                    }
                                    if (BD.TAMTRUID != 0 && BD.TAMTRUID != null)
                                    {
                                        strADRESS += " " + getDiachi((decimal)BD.TAMTRUID);
                                    }
                                    strBD += BD.TENDUONGSU + strADRESS + ".";
                                }
                                else
                                {
                                    strBD += BD.TENDUONGSU + ".";
                                }
                            }
                        }

                        List<AHC_DON_DUONGSU> dsTGTT = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
                        string TGTT = "";
                        if (dsTGTT != null)
                        {
                            foreach (var item in dsTGTT)
                            {
                                TGTT += Environment.NewLine;
                                if (item.LOAIDUONGSU == 1)
                                {
                                    if (item.GIOITINH == 0)
                                    {
                                        if (item.TAMTRUCHITIET != null || item.TAMTRUID != 0 && item.TAMTRUID != null)
                                        {
                                            string strADRESS = ", địa chỉ:";
                                            if (item.TAMTRUCHITIET != null)
                                            {
                                                strADRESS += " " + item.TAMTRUCHITIET;
                                            }
                                            if (item.TAMTRUID != 0 && item.TAMTRUID != null)
                                            {
                                                strADRESS += " " + getDiachi((decimal)item.TAMTRUID);
                                            }
                                            TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ".";
                                        }
                                        else
                                        {
                                            TGTT += "- Bà " + item.TENDUONGSU + ".";
                                        }
                                    }
                                    else
                                    {
                                        if (item.TAMTRUCHITIET != null || item.TAMTRUID != 0 && item.TAMTRUID != null)
                                        {
                                            string strADRESS = ", địa chỉ:";
                                            if (item.TAMTRUCHITIET != null)
                                            {
                                                strADRESS += " " + item.TAMTRUCHITIET;
                                            }
                                            if (item.TAMTRUID != 0 && item.TAMTRUID != null)
                                            {
                                                strADRESS += " " + getDiachi((decimal)item.TAMTRUID);
                                            }
                                            TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ".";
                                        }
                                        else
                                        {
                                            TGTT += "- Ông " + item.TENDUONGSU + ".";
                                        }
                                    }
                                }
                                else
                                {
                                    if (item.GIOITINH == 0)
                                    {
                                        if (item.TAMTRUCHITIET != null || item.TAMTRUID != 0 && item.TAMTRUID != null)
                                        {
                                            string strADRESS = ", địa chỉ:";
                                            if (item.TAMTRUCHITIET != null)
                                            {
                                                strADRESS += " " + item.TAMTRUCHITIET;
                                            }
                                            if (item.TAMTRUID != 0 && item.TAMTRUID != null)
                                            {
                                                strADRESS += " " + getDiachi((decimal)item.TAMTRUID);
                                            }
                                            TGTT += "- " + item.TENDUONGSU + strADRESS + ".";
                                        }
                                        else
                                        {
                                            TGTT += "- " + item.TENDUONGSU + ".";
                                        }
                                    }
                                    else
                                    {
                                        if (item.TAMTRUCHITIET != null || item.TAMTRUID != 0 && item.TAMTRUID != null)
                                        {
                                            string strADRESS = ", địa chỉ:";
                                            if (item.TAMTRUCHITIET != null)
                                            {
                                                strADRESS += " " + item.TAMTRUCHITIET;
                                            }
                                            if (item.TAMTRUID != 0 && item.TAMTRUID != null)
                                            {
                                                strADRESS += " " + getDiachi((decimal)item.TAMTRUID);
                                            }
                                            TGTT += "- " + item.TENDUONGSU + strADRESS + ".";
                                        }
                                        else
                                        {
                                            TGTT += "- " + item.TENDUONGSU + ".";
                                        }
                                    }
                                }
                            }
                        }

                        //TGTT = TGTT.Substring(0, TGTT.Length - 1);

                        r.NGUOINHAN = "1. " + vks.TEN + ".";
                        r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                        r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                        r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                        r.NGUOIKHANGCAO = strKC_Nguoi;
                        r.DAICHIKHANGCAO = strKC_Diachi;
                        r.NOIDUNGKHANGCAO = strKC_Noidung;
                        r.STSOBAQD = strKC_SOBAQD;
                        r.STNGAYBAQD = strKC_NgayBAQD;
                        r.STTHANGBAQD = strKC_ThangBAQD;
                        r.STNAMBAQD = strKC_NamBAQD;
                        r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Toà án nhân dân");
                        r.NAMEKCKN = nameKCKN;
                        objds.DTBM65DS.AddDTBM65DSRow(r);
                        objds.AcceptChanges();
                        rpt35HC rpt = new rpt35HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "31-HC")
                {
                    idTitle.Text = "31-HC. Thông báo nộp tiền tạm ứng án phí phúc thẩm";
                    string strND_Gioitinh = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID && x.ISMIENANPHI == 0).ToList();
                    if (lstkc.Count > 0)
                    {
                        DTBIEUMAU objds = new DTBIEUMAU();
                        foreach (AHC_SOTHAM_KHANGCAO oKC in lstkc)
                        {
                            DTBIEUMAU.DTBM30DSRow r = objds.DTBM30DS.NewDTBM30DSRow();
                            r.TENVUVIEC = strTenQHPL;
                            r.TAMUNGANPHI = oKC.ANPHI + "" == "" ? "0" : ((decimal)oKC.ANPHI == 0 ? "0" : ((decimal)oKC.ANPHI).ToString("#,#", cul));
                            r.TENTOAAN = getTenToa((decimal)oDon.TOAANID);
                            r.NOIDUNGDON = oDon.NOIDUNGKHOIKIEN;
                            AHC_DON_DUONGSU oNG = dt.AHC_DON_DUONGSU.Where(x => x.ID == oKC.DUONGSUID).FirstOrDefault();
                            if (oNG.LOAIDUONGSU == 1)
                            {
                                if (oNG.GIOITINH == 1)
                                    strND_Gioitinh = "Ông";
                                else strND_Gioitinh = "Bà";
                                if (oNG.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNG.TAMTRUID);
                                strND_Diachi = oNG.TAMTRUCHITIET + " " + strND_Diachi;

                            }
                            else
                            {
                                if (oNG.NDD_DIACHIID != null) strND_Diachi = getDiachi((decimal)oNG.NDD_DIACHIID);
                                strND_Diachi = oNG.NDD_DIACHICHITIET + " " + strND_Diachi;
                            }

                            r.TENNGUYENDON = oNG.TENDUONGSU;
                            if (oNG.LOAIDUONGSU == 1)
                            {
                                if (oNG.GIOITINH == 1)
                                    strND_Gioitinh = "Ông";
                                else strND_Gioitinh = "Bà";
                                if (oNG.TAMTRUID != null) strND_Diachi = getDiachi((decimal)oNG.TAMTRUID);
                                strND_Diachi = oNG.TAMTRUCHITIET + " " + strND_Diachi;

                            }
                            else
                            {
                                if (oNG.NDD_DIACHIID != null) strND_Diachi = getDiachi((decimal)oNG.NDD_DIACHIID);
                                strND_Diachi = oNG.NDD_DIACHICHITIET + " " + strND_Diachi;
                            }
                            r.TENGIOITINH = strND_Gioitinh;
                            r.DIACHI = strND_Diachi;
                            r.EMAIL = oNG.EMAIL;
                            r.FAX = oNG.FAX;
                            r.SODIENTHOAI = strND_Dienthoai;
                            r.DONID = oDon.ID.ToString() + oNG.ID.ToString();
                            r.DIADIEM = strDiadiem;
                            if (lstGQD.Count > 0)
                            {
                                r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                            }
                            objds.DTBM30DS.AddDTBM30DSRow(r);
                            objds.AcceptChanges();
                        }
                        rpt31HC rpt = new rpt31HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);

                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "32-HC")
                {
                    //Thông tin bản án/Quyết định kháng cáo, kháng nghị
                    //string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTAO).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTAO).ToList();

                    idTitle.Text = "32-HC. Thông báo về việc kháng cáo";
                    if (lstThuLy.Count > 0)
                    {
                        DTBIEUMAU objds = new DTBIEUMAU();
                        List<AHC_DON_DUONGSU> lstNG = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID).OrderByDescending(x => x.ISDAIDIEN).ToList();
                        List<AHC_DON_TAILIEU> lstTailieu = dt.AHC_DON_TAILIEU.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYBANGIAO).ToList();
                        int i = 0; int z = 0;
                        if (lstkc.Count > 0)
                        {
                            foreach (AHC_SOTHAM_KHANGCAO oKC in lstkc)
                            {
                                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                                AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                                AHC_DON_DUONGSU oNG = lstNG[z];
                                z++;
                                //strTenQHPL = getQuanhephapluat_name("AHN", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));
                                if (lstTailieu.Count > 0)
                                {
                                    AHC_DON_TAILIEU oTL = lstTailieu[i];
                                    r.TENTAILIEU = oTL.TENTAILIEU;
                                    i++;
                                }
                                r.NOIDUNGKHANGCAO = oKC.NOIDUNGKHANGCAO;

                                if (oNG.TAMTRUID != null) { r.DIACHINHAN = getDiachi((decimal)oNG.TAMTRUID); }
                                r.DIACHINHAN = oNG.TAMTRUCHITIET + " " + r.DIACHINHAN;
                                r.NGUOIKHANGCAO = oNG.TENDUONGSU;
                                r.DIADIEM = strDiadiem;
                                r.SOTHULY = oSTTL.SOTHULY;
                                // ngày kháng cáo
                                DateTime oNgayTL = (DateTime)oKC.NGAYKHANGCAO;
                                r.NGAYTHULY = oNgayTL.Day.ToString();
                                r.THANGTHULY = oNgayTL.Month.ToString();
                                r.NAMTHULY = oNgayTL.Year.ToString();
                                r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                                r.STTENTOAAN = getTenToa((decimal)oKC.TOAANRAQDID);
                                if (lstGQD.Count > 0)
                                {
                                    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                                }
                                decimal BAKCID = (decimal)oKC.SOQDBA;
                                List<AHC_SOTHAM_QUYETDINH> lstKCBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                                if (lstKCBA.Count > 0)
                                {
                                    r.STSOBAQD = lstKCBA[0].SOQD;
                                }
                                // ngày quyết định bản án
                                DateTime oNgayBAQD = (DateTime)oKC.NGAYQDBA;
                                r.STNGAYBAQD = oNgayBAQD.Day.ToString();
                                r.STTHANGBAQD = oNgayBAQD.Month.ToString();
                                r.STNAMBAQD = oNgayBAQD.Year.ToString();
                                objds.DTBM65DS.AddDTBM65DSRow(r);
                                objds.AcceptChanges();
                            }
                        }
                        if (lstkn.Count > 0)
                        {
                            foreach (AHC_SOTHAM_KHANGNGHI oKN in lstkn)
                            {
                                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                                AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                                AHC_DON_DUONGSU oNG = lstNG[z];
                                z++;
                                //strTenQHPL = getQuanhephapluat_name("AHN", "SOTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));
                                if (lstTailieu.Count > 0)
                                {
                                    AHC_DON_TAILIEU oTL = lstTailieu[i];
                                    r.TENTAILIEU = oTL.TENTAILIEU;
                                    i++;
                                }
                                r.NOIDUNGKHANGCAO = oKN.NOIDUNGKN;
                                if (oNG.TAMTRUID != null) { r.DIACHINHAN = getDiachi((decimal)oNG.TAMTRUID); }
                                r.DIACHINHAN = oNG.TAMTRUCHITIET + " " + r.DIACHINHAN;
                                r.NGUOIKHANGCAO = oNG.TENDUONGSU;
                                r.DIADIEM = strDiadiem;
                                //ngày kháng nghị
                                DateTime oNgayTL = (DateTime)oKN.NGAYKN;
                                r.NGAYTHULY = oNgayTL.Day.ToString();
                                r.THANGTHULY = oNgayTL.Month.ToString();
                                r.NAMTHULY = oNgayTL.Year.ToString();
                                r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                                r.STTENTOAAN = getTenToa((decimal)oKN.TOAANRAQDID);
                                if (lstGQD.Count > 0)
                                {
                                    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                                }
                                //lấy từ cột QDBA AHN_KCKN
                                List<AHC_SOTHAM_QUYETDINH> lstKCBA = dt.AHC_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
                                if (lstKCBA.Count > 0)
                                {
                                    r.STSOBAQD = lstKCBA[0].SOQD;
                                }
                                //ngày quyết định bản án
                                DateTime oNgayBAQD = (DateTime)oKN.NGAYBANAN;
                                r.STNGAYBAQD = oNgayBAQD.Day.ToString();
                                r.STTHANGBAQD = oNgayBAQD.Month.ToString();
                                r.STNAMBAQD = oNgayBAQD.Year.ToString();
                                objds.DTBM65DS.AddDTBM65DSRow(r);
                                objds.AcceptChanges();
                            }
                        }
                        rpt62DS rpt = new rpt62DS();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "36-HC") // Giống 66-DS
                {
                    string strKC_Nguoi = "", strKC_Toaan = "", strLOAIKCKN = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
                    if (lstkn.Count > 0)
                    {
                        strLOAIKCKN = "kháng nghị";
                        AHC_SOTHAM_KHANGNGHI oKN = lstkn[0];
                        strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                        if (oKN.DONVIKN == 1)
                        {
                            strKC_Nguoi = "Viện trưởng";
                            if (oKN.CAPKN == 0)
                                strKC_Nguoi = strKC_Nguoi + " " + strKC_Toaan.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                            else
                                if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getVKS((decimal)oKN.TOAAN_VKS_KN);
                        }
                        else
                        {
                            strKC_Nguoi = "Chánh án";
                            if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getTenToa((decimal)oKN.TOAAN_VKS_KN);
                        }
                    }
                    else if (lstkc.Count > 0) //Kháng cáo
                    {
                        strLOAIKCKN = "kháng cáo";
                        AHC_SOTHAM_KHANGCAO oKN = lstkc[0];
                        if (oKN.DUONGSUID != null)
                        {
                            List<AHC_DON_DUONGSU> lstDSKC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
                            if (lstDSKC.Count > 0)
                            {
                                strKC_Nguoi = lstDSKC[0].TENDUONGSU;
                                if (lstDSKC[0].LOAIDUONGSU == 1)
                                {
                                    if (lstDSKC[0].GIOITINH == 1)
                                        strKC_Nguoi = "Ông " + strKC_Nguoi;
                                    else strKC_Nguoi = "Bà " + strKC_Nguoi;
                                }
                                string strMaTCTC = lstDSKC[0].TUCACHTOTUNG_MA;
                                if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
                                    strKC_Nguoi += ", là nguyên đơn";
                                else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                                    strKC_Nguoi += ", là bị đơn";
                                else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                                    strKC_Nguoi += ", là người có quyền lợi, nghĩa vụ liên quan";
                            }
                        }
                    }
                    idTitle.Text = "36-HC. Quyết định đưa vụ án ra xét xử phúc thẩm";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "36-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.DIADIEM = strDiadiem;
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.LOAIKCKN = strLOAIKCKN;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKCKN = strKC_Nguoi;
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHDXX);
                        r.THUKY = GetThuKyPT(lstHDXX);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHDXX);
                        //Kiểm sát viên
                        objds = FillDSKiemSatVienPT(objds, lstHDXX);
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Người tham gia tố tụng
                        AHC_PHUCTHAM_BL oBL = new AHC_PHUCTHAM_BL();
                        DataTable tblNguoiTGTT = oBL.AHC_PHUCTHAM_TGTT_GETLIST(vDonID);
                        objds = FillDSNguoiTGTT(objds, tblNguoiTGTT);

                        rpt36HC rpt = new rpt36HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "37-HC") // Giống 80-DS
                {
                    string strKC_Nguoi = "", strKC_Toaan = "", strLOAIKCKN = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
                    if (lstkn.Count > 0)
                    {
                        strLOAIKCKN = "kháng nghị";
                        AHC_SOTHAM_KHANGNGHI oKN = lstkn[0];
                        strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                        if (oKN.DONVIKN == 1)
                        {
                            strKC_Nguoi = "Viện trưởng";
                            if (oKN.CAPKN == 0)
                                strKC_Nguoi = strKC_Nguoi + " " + strKC_Toaan.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                            else
                               if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getVKS((decimal)oKN.TOAAN_VKS_KN);
                        }
                        else
                        {
                            strKC_Nguoi = "Chánh án";
                            if (oKN.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getTenToa((decimal)oKN.TOAAN_VKS_KN);
                        }
                    }
                    else if (lstkc.Count > 0) //Kháng cáo
                    {
                        strLOAIKCKN = "kháng cáo";
                        AHC_SOTHAM_KHANGCAO oKN = lstkc[0];
                        if (oKN.DUONGSUID != null)
                        {
                            List<AHC_DON_DUONGSU> lstDSKC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
                            if (lstDSKC.Count > 0)
                            {
                                strKC_Nguoi = lstDSKC[0].TENDUONGSU;
                                if (lstDSKC[0].LOAIDUONGSU == 1)
                                {
                                    if (lstDSKC[0].GIOITINH == 1)
                                        strKC_Nguoi = "Ông " + strKC_Nguoi;
                                    else strKC_Nguoi = "Bà " + strKC_Nguoi;
                                }
                                string strMaTCTC = lstDSKC[0].TUCACHTOTUNG_MA;
                                if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
                                    strKC_Nguoi += ", là nguyên đơn";
                                else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                                    strKC_Nguoi += ", là bị đơn";
                                else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                                    strKC_Nguoi += ", là người có quyền lợi, nghĩa vụ liên quan";
                            }
                        }
                    }
                    idTitle.Text = "37-HC. Quyết định đưa vụ án ra xét xử phúc thẩm theo thủ tục rút gọn";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "37-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    List<AHC_PHUCTHAM_QUYETDINH> lstQDXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).ToList();
                    if (lstThuLy.Count > 0 && lstQDXX.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        AHC_PHUCTHAM_QUYETDINH oQD = lstQDXX[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.LOAIKCKN = strLOAIKCKN;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKCKN = strKC_Nguoi;

                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHDXX);
                        r.THUKY = GetThuKyPT(lstHDXX);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHDXX);
                        // Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDanPT(objds, lstHDXX);
                        //Kiểm sát viên
                        objds = FillDSKiemSatVienPT(objds, lstHDXX);
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Người tham gia tố tụng
                        AHC_PHUCTHAM_BL oBL = new AHC_PHUCTHAM_BL();
                        DataTable tblNguoiTGTT = oBL.AHC_PHUCTHAM_TGTT_GETLIST(vDonID);
                        objds = FillDSNguoiTGTT(objds, tblNguoiTGTT);

                        rpt37HC rpt = new rpt37HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "38-HC")// giống 67-DS
                {
                    string strKC_Nguoi = "", strLOAIKCKN = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();

                    idTitle.Text = "38-HC. Quyết định tạm đình chỉ xét xử phúc thẩm vụ án hành chính (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "38-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    List<AHC_PHUCTHAM_QUYETDINH> lstQDXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).ToList();

                    if (lstThuLy.Count > 0 && lstQDXX.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        AHC_PHUCTHAM_QUYETDINH oQD = lstQDXX[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.LOAIBA = "HC";
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.LOAIKCKN = strLOAIKCKN;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKCKN = strKC_Nguoi;
                        List<AHC_SOTHAM_BANAN> lstBA = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == vDonID).ToList();
                        if (lstBA.Count > 0)
                        {
                            r.STSOBAQD = lstBA[0].SOBANAN;
                            DateTime oNgayBA = (DateTime)lstBA[0].NGAYTUYENAN;
                            r.STNGAYBAQD = oNgayBA.Day.ToString();
                            r.STTHANGBAQD = oNgayBA.Month.ToString();
                            r.STNAMBAQD = oNgayBA.Year.ToString();
                            r.STTENTOAAN = getTenToa((decimal)lstBA[0].TOAANID);
                        }
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();

                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDO = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDO = lstQDLD[lstQDLD.Count - 1].TEN;
                        }

                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Kháng cáo kháng nghị
                        objds = FillDSKhangCaoKhangNghi(objds, lstkc, lstkn);

                        rpt38HC rpt = new rpt38HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "39-HC")// giống 68-DS
                {
                    string strKC_Nguoi = "", strLOAIKCKN = "";
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();

                    idTitle.Text = "39-HC. Quyết định tạm đình chỉ xét xử phúc thẩm vụ án hành chính (dành cho Hội đồng xét xử)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "39-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    List<AHC_PHUCTHAM_QUYETDINH> lstQDXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).ToList();
                    if (lstThuLy.Count > 0 && lstQDXX.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        AHC_PHUCTHAM_QUYETDINH oQD = lstQDXX[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.LOAIBA = "HC";
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.LOAIKCKN = strLOAIKCKN;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKCKN = strKC_Nguoi;
                        List<AHC_SOTHAM_BANAN> lstBA = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == vDonID).ToList();
                        if (lstBA.Count > 0)
                        {
                            r.STSOBAQD = lstBA[0].SOBANAN;
                            DateTime oNgayBA = (DateTime)lstBA[0].NGAYTUYENAN;
                            r.STNGAYBAQD = oNgayBA.Day.ToString();
                            r.STTHANGBAQD = oNgayBA.Month.ToString();
                            r.STNAMBAQD = oNgayBA.Year.ToString();
                            r.STTENTOAAN = getTenToa((decimal)lstBA[0].TOAANID);
                        }
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();

                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDO = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDO = lstQDLD[lstQDLD.Count - 1].TEN;
                        }


                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHDXX = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        //Thẩm phán chủ tọa
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHDXX);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHDXX);
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Kháng cáo kháng nghị
                        objds = FillDSKhangCaoKhangNghi(objds, lstkc, lstkn);

                        rpt39HC rpt = new rpt39HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "40-HC")// giống 69-DS
                {
                    string strKC_Nguoi = "", strLOAIKCKN = ""; ;
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
                    idTitle.Text = "40-HC. Quyết định đình chỉ xét xử phúc thẩm vụ án dân sự";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "40-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    List<AHC_PHUCTHAM_QUYETDINH> lstQDXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).ToList();
                    if (lstThuLy.Count > 0 && lstQDXX.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        AHC_PHUCTHAM_QUYETDINH oQD = lstQDXX[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.LOAIBA = "HC";
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.LOAIKCKN = strLOAIKCKN;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.NGUOIKCKN = strKC_Nguoi;
                        List<AHC_SOTHAM_BANAN> lstBA = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == vDonID).ToList();
                        if (lstBA.Count > 0)
                        {
                            r.STSOBAQD = lstBA[0].SOBANAN;
                            DateTime oNgayBA = (DateTime)lstBA[0].NGAYTUYENAN;
                            r.STNGAYBAQD = oNgayBA.Day.ToString();
                            r.STTHANGBAQD = oNgayBA.Month.ToString();
                            r.STNAMBAQD = oNgayBA.Year.ToString();
                            r.STTENTOAAN = getTenToa((decimal)lstBA[0].TOAANID);
                        }
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDO = lstQDLD[0].TEN;
                        }
                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Kháng cáo kháng nghị
                        objds = FillDSKhangCaoKhangNghi(objds, lstkc, lstkn);

                        rpt40HC rpt = new rpt40HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "41-HC")// Giống 70-DS
                {
                    List<AHC_SOTHAM_KHANGCAO> lstkc = dt.AHC_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
                    List<AHC_SOTHAM_KHANGNGHI> lstkn = dt.AHC_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
                    idTitle.Text = "41-HC. Quyết định đình chỉ xét xử phúc thẩm vụ án hành chính (dành cho Hội đồng xét xử)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "DC").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "41-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    List<AHC_PHUCTHAM_QUYETDINH> lstQDXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).ToList();

                    if (lstThuLy.Count > 0 && lstQDXX.Count > 0)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        AHC_PHUCTHAM_QUYETDINH oQD = lstQDXX[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.LOAIBA = "HC";
                        r.DIADIEM = strDiadiem;
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        List<AHC_SOTHAM_BANAN> lstBA = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == vDonID).ToList();
                        if (lstBA.Count > 0)
                        {
                            r.STSOBAQD = lstBA[0].SOBANAN;
                            DateTime oNgayBA = (DateTime)lstBA[0].NGAYTUYENAN;
                            r.STNGAYBAQD = oNgayBA.Day.ToString();
                            r.STTHANGBAQD = oNgayBA.Month.ToString();
                            r.STNAMBAQD = oNgayBA.Year.ToString();
                            r.STTENTOAAN = getTenToa((decimal)lstBA[0].TOAANID);
                        }
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.LYDO = lstQDLD[0].TEN;
                        }
                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHD);
                        // Nguyên đơn
                        objds = FillDSNguyenDon(oDon, objds, lstND);
                        //Bị đơn
                        objds = FillDSBiDon(oDon, objds, lstBD);
                        //NVLQ
                        objds = FillDSNguoiNVLQ(oDon, objds, lstNVLQ);
                        //Kháng cáo kháng nghị
                        objds = FillDSKhangCaoKhangNghi(objds, lstkc, lstkn);

                        rpt41HC rpt = new rpt41HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "44-HC")// Giống 74-DS
                {
                    idTitle.Text = "44-HC. Quyết định hoãn phiên toà phúc thẩm";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "HPT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "44-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();

                    decimal IDLQDDVAXX = 0;
                    DM_QD_LOAI oLQDRXX = dt.DM_QD_LOAI.Where(x => x.MA == "DVARXX").FirstOrDefault();
                    if (oLQDRXX != null) IDLQDDVAXX = oLQDRXX.ID;
                    AHC_PHUCTHAM_QUYETDINH QDRXX = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDDVAXX).OrderByDescending(x => x.NGAYQD).FirstOrDefault();

                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM66DSRow r = objds.DTBM66DS.NewDTBM66DSRow();
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        r.DIADIEM = strDiadiem;
                        r.SOTHULY = oSTTL.SOTHULY;
                        DateTime oNgayTL = (DateTime)oSTTL.NGAYTHULY;
                        r.NGAYTHULY = oNgayTL.Day.ToString();
                        r.THANGTHULY = oNgayTL.Month.ToString();
                        r.NAMTHULY = oNgayTL.Year.ToString();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.TENVIENKIEMSAT = r.TENTOAAN.Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                        r.SOQD = oQD.SOQD;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();

                        if (oQD.LYDO_NAME != null)
                        {
                            r.LYDO = oQD.LYDO_NAME;
                        }
                        else if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0)
                                r.LYDO = lstQDLD[lstQDLD.Count - 1].TEN;
                        }

                        if (QDRXX != null)
                        {
                            r.DVAXXSO = QDRXX.SOQD;
                            DateTime oNgayRXX = (DateTime)QDRXX.NGAYQD;
                            r.DVAXXNGAY = oNgayRXX.Day.ToString();
                            r.DVAXXTHANG = oNgayRXX.Month.ToString();
                            r.DVAXXNAM = oNgayRXX.Year.ToString();
                        }
                        //Hội đồng xét xử                       
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        r.THUKY = GetThuKyPT(lstHD);
                        objds.DTBM66DS.AddDTBM66DSRow(r);
                        objds.AcceptChanges();
                        objds = FillDSThamPhanThanhVienPT(objds, lstHD);
                        objds = FillDSKiemSatVienPT(objds, lstHD);

                        rpt44HC rpt = new rpt44HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "57-HC")
                {
                    idTitle.Text = "57-HC. Quyết định áp dụng biện pháp khẩn cấp tạm thời (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "57-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();

                        rpt57HC rpt = new rpt57HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "58-HC")
                {
                    idTitle.Text = "58-HC. Quyết định áp dụng biện pháp khẩn cấp tạm thời (dành cho Hội đồng xét xử phúc thẩm)";
                    decimal IDLQD = 0, IDQD = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "58-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.GIAIDOAN = "phúc thẩm";
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHD);
                        // Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDanPT(objds, lstHD);
                        rpt58HC rpt = new rpt58HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "59-HC")
                {
                    idTitle.Text = "59-HC. Quyết định thay đổi biện pháp khẩn cấp tạm thời (dành cho Thẩm phán)";
                    decimal IDLQD = 0, IDQD = 0, IDLQDKCTT = 0, IDQDKCTT = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "59-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    // Lấy ra quyết định áp dụng BPKCTT
                    DM_QD_LOAI oLQDKCTT = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQDKCTT != null) IDLQDKCTT = oLQDKCTT.ID;
                    DM_QD_QUYETDINH oDMQDKCTT = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQDKCTT && x.MA == "57-HC").FirstOrDefault();
                    IDQDKCTT = oDMQDKCTT.ID;
                    AHC_PHUCTHAM_QUYETDINH oQDKCTT = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDKCTT && x.QUYETDINHID == IDQDKCTT).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        // Biện pháp KCTT bị thay đổi
                        if (oQDKCTT != null)
                        {
                            r.SOQD_THAYDOI = oQDKCTT.SOQD;
                            DateTime oNgayQD_THAYDOI = (DateTime)oQDKCTT.NGAYQD;
                            r.NGAYQD_THAYDOI = oNgayQD_THAYDOI.Day.ToString();
                            r.THANGQD_THAYDOI = oNgayQD_THAYDOI.Month.ToString();
                            r.NAMQD_THAYDOI = oNgayQD_THAYDOI.Year.ToString();
                            r.NOIDUNGYC_THAYDOI = oQDKCTT.GHICHU;
                        }
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();

                        rpt59HC rpt = new rpt59HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
                else if (vMaBC == "60-HC")
                {
                    idTitle.Text = "60-HC. Quyết định thay đổi biện pháp khẩn cấp tạm thời (dành cho Hội đồng xét xử phúc thẩm)";
                    decimal IDLQD = 0, IDQD = 0, IDLQDKCTT = 0, IDQDKCTT = 0;
                    DM_QD_LOAI oLQD = dt.DM_QD_LOAI.Where(x => x.MA == "TDBPTT").FirstOrDefault();
                    if (oLQD != null) IDLQD = oLQD.ID;
                    DM_QD_QUYETDINH oDMQD = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQD && x.MA == "60-HC").FirstOrDefault();
                    IDQD = oDMQD.ID;
                    AHC_PHUCTHAM_QUYETDINH oQD = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQD && x.QUYETDINHID == IDQD).FirstOrDefault();
                    // Lấy ra quyết định áp dụng BPKCTT
                    DM_QD_LOAI oLQDKCTT = dt.DM_QD_LOAI.Where(x => x.MA == "ADBPTT").FirstOrDefault();
                    if (oLQDKCTT != null) IDLQDKCTT = oLQDKCTT.ID;
                    DM_QD_QUYETDINH oDMQDKCTT = dt.DM_QD_QUYETDINH.Where(x => x.LOAIID == IDLQDKCTT && x.MA == "57-HC").FirstOrDefault();
                    IDQDKCTT = oDMQDKCTT.ID;
                    AHC_PHUCTHAM_QUYETDINH oQDKCTT = dt.AHC_PHUCTHAM_QUYETDINH.Where(x => x.DONID == vDonID && x.LOAIQDID == IDLQDKCTT && x.QUYETDINHID == IDQDKCTT).FirstOrDefault();
                    if (lstThuLy.Count > 0 && oQD != null)
                    {
                        AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                        //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                        //strTenQHPL = oTQHPL.TEN;
                        strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                        DTBIEUMAU objds = new DTBIEUMAU();
                        DTBIEUMAU.DTBM17DSRow r = objds.DTBM17DS.NewDTBM17DSRow();
                        r.GIAIDOAN = "phúc thẩm";
                        r.TENTOAAN = getTenToa((decimal)oSTTL.TOAANID);
                        r.SOQD = oQD.SOQD;
                        r.DIADIEM = strDiadiem;
                        DateTime oNgayQD = (DateTime)oQD.NGAYQD;
                        r.NGAYQD = oNgayQD.Day.ToString();
                        r.THANGQD = oNgayQD.Month.ToString();
                        r.NAMQD = oNgayQD.Year.ToString();
                        r.NOIDUNGYEUCAU = oQD.GHICHU;
                        // Người yêu cầu
                        AHC_DON_DUONGSU oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        // Người bị yêu cầu
                        oNguoiYC = dt.AHC_DON_DUONGSU.Where(x => x.ID == oQD.NGUOIBIYEUCAUID).FirstOrDefault();
                        if (oNguoiYC != null)
                        {
                            r.NGUOIBIYEUCAU = oNguoiYC.TENDUONGSU;
                            r.NGUOIBIYC_DIACHI = oNguoiYC.TAMTRUCHITIET + "" == "" ? oNguoiYC.HKTTCHITIET : oNguoiYC.TAMTRUCHITIET;
                            DM_DATAITEM oTuCachTT = dt.DM_DATAITEM.Where(x => x.MA == oNguoiYC.TUCACHTOTUNG_MA).FirstOrDefault();
                            r.NGUOIBIYC_TUCACHTOTUNG = oTuCachTT.TEN;
                        }
                        if (oQD.LYDOID != null)
                        {
                            List<DM_QD_QUYETDINH_LYDO> lstQDLD = dt.DM_QD_QUYETDINH_LYDO.Where(x => x.ID == oQD.LYDOID).ToList();
                            if (lstQDLD.Count > 0) r.QD_LYDO = lstQDLD[0].TEN;
                        }
                        r.QUANHEPHAPLUAT = strTenQHPL;
                        List<AHC_PHUCTHAM_HDXX> lstHD = dt.AHC_PHUCTHAM_HDXX.Where(x => x.DONID == vDonID).ToList();
                        r.THAMPHANCHUTOA = GetThamPhanChuToaPT(lstHD);
                        // Biện pháp KCTT bị thay đổi
                        if (oQDKCTT != null)
                        {
                            r.SOQD_THAYDOI = oQDKCTT.SOQD;
                            DateTime oNgayQD_THAYDOI = (DateTime)oQDKCTT.NGAYQD;
                            r.NGAYQD_THAYDOI = oNgayQD_THAYDOI.Day.ToString();
                            r.THANGQD_THAYDOI = oNgayQD_THAYDOI.Month.ToString();
                            r.NAMQD_THAYDOI = oNgayQD_THAYDOI.Year.ToString();
                            r.NOIDUNGYC_THAYDOI = oQDKCTT.GHICHU;
                        }
                        objds.DTBM17DS.AddDTBM17DSRow(r);
                        objds.AcceptChanges();
                        //Thẩm phán thành viên
                        objds = FillDSThamPhanThanhVienPT(objds, lstHD);
                        // Hội thẩm nhân dân
                        objds = FillDSHoiThamNhanDanPT(objds, lstHD);

                        rpt60HC rpt = new rpt60HC();
                        rpt.DataSource = objds;
                        rptView.OpenReport(rpt);
                    }
                    else
                    {
                        ltlmsg.InnerText = "Không tìm thấy dữ liệu của báo cáo " + vMaBC + ".";
                        return;
                    }
                }
            }
            catch (Exception ex) { ltlmsg.InnerText = ex.Message; }
        }
        private string GetThamPhanDuKhuyet(List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            string TPDKName = "";
            List<AHC_SOTHAM_HDXX> lstDK = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET).ToList();
            if (lstDK.Count > 0)
            {
                decimal IDDK = (decimal)lstDK[0].CANBOID;
                DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == IDDK).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    TPDKName = "Ông " + oCanbo.HOTEN;
                else
                    TPDKName = "Bà " + oCanbo.HOTEN;
            }
            return TPDKName;
        }
        private string GetThamPhanDuKhuyetPT(List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            string TPDKName = "";
            List<AHC_PHUCTHAM_HDXX> lstDK = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANDUKHUYET).ToList();
            if (lstDK.Count > 0)
            {
                decimal IDDK = (decimal)lstDK[0].CANBOID;
                DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == IDDK).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    TPDKName = "Ông " + oCanbo.HOTEN;
                else
                    TPDKName = "Bà " + oCanbo.HOTEN;
            }
            return TPDKName;
        }
        private string GetThuKy(List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            string ThuKyName = "";
            List<AHC_SOTHAM_HDXX> lstTK = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THUKY).ToList();
            if (lstTK.Count > 0)
            {
                decimal IDTK = (decimal)lstTK[0].CANBOID;
                DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == IDTK).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    ThuKyName = "Ông " + oCanbo.HOTEN;
                else
                    ThuKyName = "Bà " + oCanbo.HOTEN;
            }
            return ThuKyName;
        }
        private string GetThuKyPT(List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            string ThuKyName = "";
            List<AHC_PHUCTHAM_HDXX> lstTK = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THUKY).ToList();
            if (lstTK.Count > 0)
            {
                decimal IDTK = (decimal)lstTK[0].CANBOID;
                DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == IDTK).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    ThuKyName = "Ông " + oCanbo.HOTEN;
                else
                    ThuKyName = "Bà " + oCanbo.HOTEN;
            }
            return ThuKyName;
        }
        private string GetThamPhanChuToa(List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            string TPChuToaName = "";
            if (lstHDXX != null && lstHDXX.Count > 0)
            {
                AHC_SOTHAM_HDXX oChutoa = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault();
                if (oChutoa != null && oChutoa.CANBOID > 0)
                {
                    DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == oChutoa.CANBOID).FirstOrDefault();
                    if (oCanbo != null)
                    {
                        if (oCanbo.GIOITINH == 1)
                        {
                            TPChuToaName = "Ông " + oCanbo.HOTEN;
                        }
                        else if (oCanbo.GIOITINH == 0)
                        {
                            TPChuToaName = "Bà " + oCanbo.HOTEN;
                        }
                    }
                }
            }
            return TPChuToaName;
        }
        private string GetThamPhanChuToaPT(List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            string TPChuToaName = "";
            if (lstHDXX != null && lstHDXX.Count > 0)
            {
                AHC_PHUCTHAM_HDXX oChutoa = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHAN).FirstOrDefault();
                if (oChutoa != null && oChutoa.CANBOID > 0)
                {
                    DM_CANBO oCanbo = dt.DM_CANBO.Where(x => x.ID == oChutoa.CANBOID).FirstOrDefault();
                    if (oCanbo != null)
                    {
                        if (oCanbo.GIOITINH == 1)
                        {
                            TPChuToaName = "Ông " + oCanbo.HOTEN;
                        }
                        else if (oCanbo.GIOITINH == 0)
                        {
                            TPChuToaName = "Bà " + oCanbo.HOTEN;
                        }
                    }
                }
            }
            return TPChuToaName;
        }
        private string getChanhAnByToaAn(decimal ToaAnID)
        {
            string TenChanhAn = ""; decimal cvChanhAnID = 0;
            DM_DATAGROUP gChucVu = dt.DM_DATAGROUP.Where(x => x.MA == ENUM_DANHMUC.CHUCVU).FirstOrDefault();
            if (gChucVu != null)
            {
                DM_DATAITEM cvChanhAn = dt.DM_DATAITEM.Where(x => x.MA == ENUM_CHUCVU.CHUCVU_CA && x.GROUPID == gChucVu.ID).FirstOrDefault();
                if (cvChanhAn != null)
                {
                    cvChanhAnID = cvChanhAn.ID;
                }
            }
            DM_CANBO cbChanhAn = dt.DM_CANBO.Where(x => x.TOAANID == ToaAnID && x.CHUCVUID == cvChanhAnID).FirstOrDefault();
            if (cbChanhAn != null)
            {
                TenChanhAn = cbChanhAn.HOTEN;
            }
            return TenChanhAn;
        }
        private DTBIEUMAU FillDSNguyenDon(AHC_DON oDon, DTBIEUMAU dtbm, List<AHC_DON_DUONGSU> lstNguyenDon)
        {
            foreach (AHC_DON_DUONGSU ods in lstNguyenDon)
            {
                DTBIEUMAU.DTNGUYENDONRow nd = dtbm.DTNGUYENDON.NewDTNGUYENDONRow();
                nd.DONID = oDon.ID.ToString();
                nd.DUONGSUID = ods.ID.ToString();
                nd.TENDUONGSU = ods.TENDUONGSU;
                if (ods.LOAIDUONGSU == 1)
                {
                    if (ods.GIOITINH == 1)
                        nd.TENGIOITINH = "Ông";
                    else nd.TENGIOITINH = "Bà";
                }
                nd.DIENTHOAI = ods.DIENTHOAI;
                nd.EMAIL = ods.EMAIL;
                if (ods.TAMTRUID != null) nd.DIACHI = getDiachi((decimal)ods.TAMTRUID);
                nd.DIACHI = ods.TAMTRUCHITIET + " " + nd.DIACHI;
                dtbm.DTNGUYENDON.AddDTNGUYENDONRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSBiDon(AHC_DON oDon, DTBIEUMAU dtbm, List<AHC_DON_DUONGSU> lstBiDon)
        {
            foreach (AHC_DON_DUONGSU ods in lstBiDon)
            {
                DTBIEUMAU.DTBIDONRow nd = dtbm.DTBIDON.NewDTBIDONRow();
                nd.DONID = oDon.ID.ToString();
                nd.DUONGSUID = ods.ID.ToString();
                nd.TENDUONGSU = ods.TENDUONGSU;
                if (ods.LOAIDUONGSU == 1)
                {
                    if (ods.GIOITINH == 1)
                        nd.TENGIOITINH = "Ông";
                    else nd.TENGIOITINH = "Bà";
                }
                nd.DIENTHOAI = ods.DIENTHOAI;
                nd.EMAIL = ods.EMAIL;
                if (ods.TAMTRUID != null) nd.DIACHI = getDiachi((decimal)ods.TAMTRUID);
                nd.DIACHI = ods.TAMTRUCHITIET + " " + nd.DIACHI;
                dtbm.DTBIDON.AddDTBIDONRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSNguoiNVLQ(AHC_DON oDon, DTBIEUMAU dtbm, List<AHC_DON_DUONGSU> lstNVLQ)
        {
            foreach (AHC_DON_DUONGSU ods in lstNVLQ)
            {
                DTBIEUMAU.DTNVLQRow nd = dtbm.DTNVLQ.NewDTNVLQRow();
                nd.DONID = oDon.ID.ToString();
                nd.DUONGSUID = ods.ID.ToString();
                nd.TENDUONGSU = ods.TENDUONGSU;
                if (ods.LOAIDUONGSU == 1)
                {
                    if (ods.GIOITINH == 1)
                        nd.TENGIOITINH = "Ông";
                    else nd.TENGIOITINH = "Bà";
                }
                nd.DIENTHOAI = ods.DIENTHOAI;
                nd.EMAIL = ods.EMAIL;
                if (ods.TAMTRUID != null) nd.DIACHI = getDiachi((decimal)ods.TAMTRUID);
                nd.DIACHI = ods.TAMTRUCHITIET + " " + nd.DIACHI;
                dtbm.DTNVLQ.AddDTNVLQRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSHoiThamNhanDan(DTBIEUMAU dtbm, List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            List<AHC_SOTHAM_HDXX> lstHD = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.HTND).ToList();
            DTBIEUMAU.DTHOITHAMRow nd; DM_CANBO oCanbo;
            foreach (AHC_SOTHAM_HDXX oT in lstHD)
            {
                nd = dtbm.DTHOITHAM.NewDTHOITHAMRow();
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    nd.TENHOITHAM = "Ông " + oCanbo.HOTEN;
                else
                    nd.TENHOITHAM = "Bà " + oCanbo.HOTEN;
                dtbm.DTHOITHAM.AddDTHOITHAMRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSHoiThamNhanDanPT(DTBIEUMAU dtbm, List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            List<AHC_PHUCTHAM_HDXX> lstHD = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.HTND).ToList();
            DTBIEUMAU.DTHOITHAMRow nd; DM_CANBO oCanbo;
            foreach (AHC_PHUCTHAM_HDXX oT in lstHD)
            {
                nd = dtbm.DTHOITHAM.NewDTHOITHAMRow();
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo.GIOITINH == 1)
                    nd.TENHOITHAM = "Ông " + oCanbo.HOTEN;
                else
                    nd.TENHOITHAM = "Bà " + oCanbo.HOTEN;
                dtbm.DTHOITHAM.AddDTHOITHAMRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSThamPhanThanhVien(DTBIEUMAU dtbm, List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            List<AHC_SOTHAM_HDXX> lst = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX).ToList();
            DTBIEUMAU.DTTHAMPHANRow nd; DM_CANBO oCanbo;
            foreach (AHC_SOTHAM_HDXX oT in lst)
            {
                nd = dtbm.DTTHAMPHAN.NewDTTHAMPHANRow();
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (oCanbo.GIOITINH == 1)
                        nd.TENTHAMPHAN = "Ông " + oCanbo.HOTEN;
                    else
                        nd.TENTHAMPHAN = "Bà " + oCanbo.HOTEN;
                }
                dtbm.DTTHAMPHAN.AddDTTHAMPHANRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSThamPhanThanhVienPT(DTBIEUMAU dtbm, List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            List<AHC_PHUCTHAM_HDXX> lst = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.THAMPHANHDXX).ToList();
            DTBIEUMAU.DTTHAMPHANRow nd; DM_CANBO oCanbo;
            foreach (AHC_PHUCTHAM_HDXX oT in lst)
            {
                nd = dtbm.DTTHAMPHAN.NewDTTHAMPHANRow();
                oCanbo = dt.DM_CANBO.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (oCanbo.GIOITINH == 1)
                        nd.TENTHAMPHAN = "Ông " + oCanbo.HOTEN;
                    else
                        nd.TENTHAMPHAN = "Bà " + oCanbo.HOTEN;
                }
                dtbm.DTTHAMPHAN.AddDTTHAMPHANRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSKiemSatVien(DTBIEUMAU dtbm, List<AHC_SOTHAM_HDXX> lstHDXX)
        {
            List<AHC_SOTHAM_HDXX> lst = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.KIEMSOATVIEN).ToList();
            DTBIEUMAU.DTKIEMSATVIENRow nd; DM_CANBOVKS oCanbo;
            foreach (AHC_SOTHAM_HDXX oT in lst)
            {
                nd = dtbm.DTKIEMSATVIEN.NewDTKIEMSATVIENRow();
                oCanbo = dt.DM_CANBOVKS.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (oCanbo.GIOITINH == 1)
                        nd.TENKIEMSATVIEN = "Ông " + oCanbo.HOTEN;
                    else
                        nd.TENKIEMSATVIEN = "Bà " + oCanbo.HOTEN;
                }
                dtbm.DTKIEMSATVIEN.AddDTKIEMSATVIENRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSKiemSatVienPT(DTBIEUMAU dtbm, List<AHC_PHUCTHAM_HDXX> lstHDXX)
        {
            List<AHC_PHUCTHAM_HDXX> lst = lstHDXX.Where(x => x.MAVAITRO == ENUM_NGUOITIENHANHTOTUNG.KIEMSOATVIEN).ToList();
            DTBIEUMAU.DTKIEMSATVIENRow nd; DM_CANBOVKS oCanbo;
            foreach (AHC_PHUCTHAM_HDXX oT in lst)
            {
                nd = dtbm.DTKIEMSATVIEN.NewDTKIEMSATVIENRow();
                oCanbo = dt.DM_CANBOVKS.Where(x => x.ID == oT.CANBOID).FirstOrDefault();
                if (oCanbo != null)
                {
                    if (oCanbo.GIOITINH == 1)
                        nd.TENKIEMSATVIEN = "Ông " + oCanbo.HOTEN;
                    else
                        nd.TENKIEMSATVIEN = "Bà " + oCanbo.HOTEN;
                }
                dtbm.DTKIEMSATVIEN.AddDTKIEMSATVIENRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSNguoiTGTT(DTBIEUMAU dtbm, DataTable DSNguoiTGTT)
        {
            DTBIEUMAU.DTNGUOITGTTRow nd;
            foreach (DataRow dr in DSNguoiTGTT.Rows)
            {
                nd = dtbm.DTNGUOITGTT.NewDTNGUOITGTTRow();
                nd.TENNGUOITGTT = dr["HOTEN"] + "";
                nd.DIACHI = "; Địa chỉ: " + dr["TAMTRU"] + "";
                dtbm.DTNGUOITGTT.AddDTNGUOITGTTRow(nd);
                dtbm.AcceptChanges();
            }
            return dtbm;
        }
        private DTBIEUMAU FillDSKhangCaoKhangNghi(DTBIEUMAU dtbm, List<AHC_SOTHAM_KHANGCAO> lstKC, List<AHC_SOTHAM_KHANGNGHI> lstKN)
        {
            string strKC_Nguoi = "";
            foreach (AHC_SOTHAM_KHANGNGHI kn in lstKN)
            {
                DTBIEUMAU.DTKCKNRow k = dtbm.DTKCKN.NewDTKCKNRow();
                if (kn.DONVIKN == 1)
                {
                    strKC_Nguoi = "Viện trưởng";
                    if (kn.CAPKN == 0)
                        strKC_Nguoi = strKC_Nguoi + " " + getTenToa((decimal)kn.TOAANRAQDID).Replace("Tòa án nhân dân", "Viện kiểm sát nhân dân");
                    else
                        if (kn.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getVKS((decimal)kn.TOAAN_VKS_KN);
                    k.NGUOI = strKC_Nguoi + ", kháng nghị: ";
                    k.NOIDUNG = kn.NOIDUNGKN;

                }
                else
                {
                    strKC_Nguoi = "Chánh án";
                    if (kn.TOAAN_VKS_KN != null) strKC_Nguoi = strKC_Nguoi + " " + getTenToa((decimal)kn.TOAAN_VKS_KN);
                    k.NGUOI = strKC_Nguoi + ", kháng nghị: ";
                    k.NOIDUNG = kn.NOIDUNGKN;
                }
                DateTime oNgayKN = (DateTime)kn.NGAYKN;
                k.NGAY = oNgayKN.Day.ToString();
                k.THANG = oNgayKN.Month.ToString();
                k.NAM = oNgayKN.Year.ToString();
                dtbm.DTKCKN.AddDTKCKNRow(k);
            }
            foreach (AHC_SOTHAM_KHANGCAO kc in lstKC)
            {
                DTBIEUMAU.DTKCKNRow k = dtbm.DTKCKN.NewDTKCKNRow();
                if (kc.DUONGSUID != null)
                {
                    List<AHC_DON_DUONGSU> lstDSKC = dt.AHC_DON_DUONGSU.Where(x => x.ID == kc.DUONGSUID).ToList();
                    if (lstDSKC.Count > 0)
                    {
                        strKC_Nguoi = lstDSKC[0].TENDUONGSU;
                        if (lstDSKC[0].LOAIDUONGSU == 1)
                        {
                            if (lstDSKC[0].GIOITINH == 1)
                                strKC_Nguoi = "Ông " + strKC_Nguoi;
                            else strKC_Nguoi = "Bà " + strKC_Nguoi;
                        }
                        string strMaTCTC = lstDSKC[0].TUCACHTOTUNG_MA;
                        if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON)
                            strKC_Nguoi += ", là nguyên đơn";
                        else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.BIDON)
                            strKC_Nguoi += ", là bị đơn";
                        else if (strMaTCTC == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ)
                            strKC_Nguoi += ", là người có quyền lợi, nghĩa vụ liên quan";
                        strKC_Nguoi = strKC_Nguoi + ", kháng cáo: ";
                    }
                }
                k.NOIDUNG = kc.NOIDUNGKHANGCAO;
                k.NGUOI = strKC_Nguoi;
                DateTime oNgayKC = (DateTime)kc.NGAYKHANGCAO;
                k.NGAY = oNgayKC.Day.ToString();
                k.THANG = oNgayKC.Month.ToString();
                k.NAM = oNgayKC.Year.ToString();
                dtbm.DTKCKN.AddDTKCKNRow(k);
            }
            dtbm.AcceptChanges();
            return dtbm;
        }

    }
}