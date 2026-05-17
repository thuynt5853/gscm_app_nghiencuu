using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using BL.GSTP;
using System.Data;
using BL.GSTP.THA;
using System.Web.Services;
using System.IO;
using System.Configuration;
using System.Reflection;
using Aspose.Words;

namespace WEB.GSTP.UserControl
{
    public partial class Header : System.Web.UI.UserControl
    {
        GSTPContext dt = new GSTPContext();
        string pathTemplateWord = ConfigurationManager.AppSettings["TemplateWordSTPT"];

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";

                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                string strMaHeThong = Session["MaHeThong"] + "";
                if (strMaHeThong == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");


                lstUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (!IsPostBack)
                {
                    //List<QT_CHUONGTRINH> lst = dt.QT_CHUONGTRINH.OrderBy(x => x.THUTU).ToList();
                    decimal IDHethong = Convert.ToDecimal(strMaHeThong);
                    //Load các Hệ thống khác
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
                    decimal USERID = Convert.ToDecimal(strUserID);
                    DataTable lstHT;
                    string strSessionKeyHT = "HETHONGGETBY_" + USERID.ToString();
                    if (Session[strSessionKeyHT] == null)
                        lstHT = oBL.QT_HETHONG_GETBYUSER(USERID);
                    else
                        lstHT = (DataTable)Session[strSessionKeyHT];
                    liGSTP.Visible = liQLA.Visible = liTDKT.Visible = liTCCB.Visible = liQTHT.Visible = false;
                    if (lstHT.Rows.Count == 1) lbtBack.Visible = false;
                    if (lstHT.Rows.Count > 0)
                    {
                        foreach (DataRow r in lstHT.Rows)
                        {
                            switch (r["MA"] + "")
                            {
                                case "GSTP":
                                    liGSTP.Visible = true;
                                    break;
                                case "QLA":
                                    liQLA.Visible = true;
                                    break;
                                case "GDT":
                                    liGDT.Visible = true;
                                    break;
                                case "TDKT":
                                    liTDKT.Visible = true;
                                    break;
                                case "TCCB":
                                    liTCCB.Visible = true;
                                    break;
                                case "QTHT":
                                    liQTHT.Visible = true;
                                    break;
                            }
                        }
                    }

                    QT_HETHONG oHT = dt.QT_HETHONG.Where(x => x.ID == IDHethong).FirstOrDefault();
                    decimal TOAAN_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                    DM_TOAAN otToaAN = dt.DM_TOAAN.Where(x => x.ID == TOAAN_ID).FirstOrDefault();
                    lbtThemmoi.Visible = true;
                    if (otToaAN.LOAITOA == "CAPCAO" || otToaAN.LOAITOA == "TOICAO") lbtThemmoi.Visible = false;
                    lstHethong.Text = oHT.TEN.ToString().ToUpper() + "&nbsp;&nbsp; -&nbsp;&nbsp; " + otToaAN.MA_TEN.ToUpper();
                    if (Session[ENUM_SESSION.SESSION_PHONGBANID] + "" == "62")//anhvh add 12/10/2020 phòng văn thư
                    {
                        lstHethong.Text = "QUẢN LÝ VĂN BẢN ĐẾN - TÒA ÁN NHÂN DÂN TỐI CAO";
                    }
                    DataTable lst;
                    string strSessionKey = "CHUONGTRINH_" + USERID.ToString() + "_" + IDHethong.ToString();
                    if (Session[strSessionKey] == null)
                        lst = oBL.QT_CHUONGTRINH_GETBYUSER(USERID, IDHethong);
                    else
                        lst = (DataTable)Session[strSessionKey];
                    rptMenu.DataSource = lst;
                    rptMenu.DataBind();
                    divSearch.Visible = false;
                    if (oHT.MA == "GSTP")
                    {
                        decimal ThamPhanID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
                        LoadGhimThamPhan(ThamPhanID);
                        divGSTP.Visible = true;
                    }
                    else
                    {
                        divGSTP.Visible = false;
                    }

                    string strMaCT = Session["MaChuongTrinh"] + "";
                    //-------------
                    if (strMaCT == "HDSD_APP")
                    {
                        lk_HDSD.CssClass = "menubutton_menu";
                        lbtTrangchu.CssClass = "menubuttonActive";
                    }
                    else
                        lk_HDSD.CssClass = "menubutton_menu";
                    //----------
                    if (otToaAN.LOAITOA == "CAPTINH" && strMaCT == ENUM_LOAIAN.BPXLHC) lbtThemmoi.Visible = false;
                    if (strMaCT == ENUM_LOAIAN.AN_GDTTT) lbtThemmoi.Visible = false;
                    if (strMaCT != "" & strMaCT != "0")
                    {
                        bool flag = false;
                        foreach (RepeaterItem oItem in rptMenu.Items)
                        {
                            LinkButton cmdButton = (LinkButton)oItem.FindControl("lbtChuongTrinh");
                            String ND_id = cmdButton.CommandArgument.ToString();
                            String[] ND_id_arr = ND_id.Split(';');
                            if (ND_id_arr[0] == strMaCT)
                            {
                                cmdButton.CssClass = "menubuttonActive";
                                flag = true;
                            }
                            else
                                cmdButton.CssClass = "menubutton";
                        }
                        QT_CHUONGTRINH oT = dt.QT_CHUONGTRINH.Where(x => x.MA == strMaCT).FirstOrDefault();
                        if (oT.ISLOAIAN == 1) divSearch.Visible = true;
                        if (flag == true) lbtTrangchu.CssClass = "menubutton";

                        if (strMaCT == "AN_HINHSU")
                        {
                            txtSearch.Attributes.Add("placeholder", "Tên bị can");
                        }
                        else
                        {
                            txtSearch.Attributes.Add("placeholder", "Tên đương sự");
                        }

                        string strIDVUAN = Session[strMaCT] + "";
                        if ((strIDVUAN == "" || strIDVUAN == "0") && strMaCT != ENUM_LOAIAN.AN_GSTP)
                        {
                            lstTenvuan.Text = "Bạn chưa chọn vụ án để lưu thông tin !";
                            cmdIn.Visible = lbtChitiet.Visible = lbtHuyghim.Visible = lbtTongdat.Visible = false;
                            return;
                        }
                        decimal IDVuViec = 0;
                        DM_TOAAN oTA = new DM_TOAAN();
                        string strNgayVuViec = "";
                        string strTieudeNVV = "Ngày vụ việc";
                        if (strMaCT == ENUM_LOAIAN.AN_HINHSU)
                        {
                            lbtChitiet.Text = "Chi tiết vụ án";
                        }
                        else
                        {
                            lbtChitiet.Text = "Chi tiết vụ việc";
                        }
                        switch (strMaCT)
                        {
                            case ENUM_LOAIAN.AN_HINHSU:
                                #region "Hình sự"
                                //Thông tin vụ án dân sự
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);
                                AHS_VUAN obj = dt.AHS_VUAN.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = obj.MAVUAN;
                                lstTenvuan.Text = obj.TENVUAN;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == obj.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                string NgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                LoadBaocao(IDVuViec, 1, (decimal)obj.MAGIAIDOAN);
                                switch (Convert.ToInt16(obj.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Ngày giao hồ sơ";
                                        NgayVuViec = ((DateTime)obj.NGAYGIAO).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        AHS_SOTHAM_THULY objST = dt.AHS_SOTHAM_THULY.Where(x => x.VUANID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            NgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        AHS_PHUCTHAM_THULY objPhucTham = dt.AHS_PHUCTHAM_THULY.Where(x => x.VUANID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            NgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (obj.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == obj.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        NgayVuViec = ((DateTime)obj.NGAYXAYRA).ToString("dd/MM/yyyy");
                                        break;

                                }
                                lstNgayvuan.Text = NgayVuViec;
                                lstTitleNgay.Text = strTieudeNVV;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_DANSU:
                                #region "Dân sự"
                                //Thông tin vụ án dân sự
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
                                ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDon.MAVUVIEC;
                                lstTenvuan.Text = oDon.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";

                                if (oDon.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 2, (decimal)oDon.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDon.MAGIAIDOAN == null ? 1 : oDon.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDon.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        ADS_SOTHAM_THULY objST = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        ADS_PHUCTHAM_THULY objPhucTham = dt.ADS_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDon.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDon.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                                #region "HNGD"
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                                AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonHN.MAVUVIEC;
                                lstTenvuan.Text = oDonHN.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonHN.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                if (oDonHN.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 3, (decimal)oDonHN.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonHN.MAGIAIDOAN == null ? 1 : oDonHN.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonHN.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        AHN_SOTHAM_THULY objST = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        AHN_PHUCTHAM_THULY objPhucTham = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonHN.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonHN.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                                #region "KDTM"
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                                AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonKT.MAVUVIEC;
                                lstTenvuan.Text = oDonKT.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonKT.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                if (oDonKT.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 4, (decimal)oDonKT.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonKT.MAGIAIDOAN == null ? 1 : oDonKT.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonKT.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        AKT_SOTHAM_THULY objST = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        AKT_PHUCTHAM_THULY objPhucTham = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonKT.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonKT.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_LAODONG:
                                #region "LD"
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
                                ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonLD.MAVUVIEC;
                                lstTenvuan.Text = oDonLD.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonLD.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                if (oDonLD.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 5, (decimal)oDonLD.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonLD.MAGIAIDOAN == null ? 1 : oDonLD.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonLD.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        ALD_SOTHAM_THULY objST = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        ALD_PHUCTHAM_THULY objPhucTham = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonLD.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonLD.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_HANHCHINH:
                                #region "HC"
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                                AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonHC.MAVUVIEC;
                                lstTenvuan.Text = oDonHC.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonHC.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                if (oDonHC.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 6, (decimal)oDonHC.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonHC.MAGIAIDOAN == null ? 1 : oDonHC.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonHC.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        AHC_SOTHAM_THULY objST = dt.AHC_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        AHC_PHUCTHAM_THULY objPhucTham = dt.AHC_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonHC.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonHC.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_PHASAN:
                                #region "PS"
                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                                APS_DON oDonPS = dt.APS_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonPS.MAVUVIEC;
                                lstTenvuan.Text = oDonPS.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonPS.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                if (oDonPS.HINHTHUCNHANDON == 3) lttTitleMaVuAn.Text = "@Mã vụ việc";
                                LoadBaocao(IDVuViec, 7, (decimal)oDonPS.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonPS.MAGIAIDOAN == null ? 1 : oDonPS.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonPS.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        APS_SOTHAM_THULY objST = dt.APS_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        APS_PHUCTHAM_THULY objPhucTham = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonPS.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonPS.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.BPXLHC:
                                #region "XLHC"

                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
                                XLHC_DON oDonXL = dt.XLHC_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonXL.MAVUVIEC;
                                lstTenvuan.Text = oDonXL.TENVUVIEC;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonXL.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN.Replace("Tòa án nhân dân", "TAND");
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày vụ việc";
                                LoadBaocao(IDVuViec, 8, (decimal)oDonXL.MAGIAIDOAN);
                                switch (Convert.ToInt16(oDonXL.MAGIAIDOAN == null ? 1 : oDonXL.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Nhận hồ sơ";
                                        strNgayVuViec = ((DateTime)oDonXL.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý sơ thẩm";
                                        XLHC_SOTHAM_THULY objST = dt.XLHC_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objST != null)
                                            strNgayVuViec = ((DateTime)objST.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.PHUCTHAM:
                                        strTieudeNVV = "Thụ lý phúc thẩm";
                                        XLHC_PHUCTHAM_THULY objPhucTham = dt.XLHC_PHUCTHAM_THULY.Where(x => x.DONID == IDVuViec).FirstOrDefault();
                                        if (objPhucTham != null)
                                            strNgayVuViec = ((DateTime)objPhucTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        if (oDonXL.TOAPHUCTHAMID != null)
                                        {
                                            DM_TOAAN oTAPT = dt.DM_TOAAN.Where(x => x.ID == oDonXL.TOAPHUCTHAMID).FirstOrDefault();
                                            lstToaan.Text = oTAPT.TEN.Replace("Tòa án nhân dân", "TAND");
                                        }
                                        break;
                                    case ENUM_GIAIDOANVUAN.THULYGDT:
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_GSTP:
                                #region "GSTP"
                                decimal ThamPhanID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GSTP]);
                                LoadGhimThamPhan(ThamPhanID);
                                divSearch.Visible = false;
                                divGSTP.Visible = true;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_GDTTT:
                                #region "GDT TT"

                                IDVuViec = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_GDTTT]);
                                GDTTT_DON oDonGDT = dt.GDTTT_DON.Where(x => x.ID == IDVuViec).FirstOrDefault();
                                lstMavuan.Text = oDonGDT.MADON;
                                lstTenvuan.Text = oDonGDT.NGUOIGUI_HOTEN;

                                oTA = dt.DM_TOAAN.Where(x => x.ID == oDonGDT.TOAANID).FirstOrDefault();
                                lstToaan.Text = oTA.TEN;
                                strNgayVuViec = "";
                                strTieudeNVV = "Ngày nhận";
                                switch (Convert.ToInt16(oDonGDT.MAGIAIDOAN == null ? 1 : oDonGDT.MAGIAIDOAN))
                                {
                                    case ENUM_GIAIDOANVUAN.HOSO:
                                        strTieudeNVV = "Ngày nhận";
                                        strNgayVuViec = ((DateTime)oDonGDT.NGAYNHANDON).ToString("dd/MM/yyyy");
                                        break;
                                    case ENUM_GIAIDOANVUAN.SOTHAM:
                                        strTieudeNVV = "Thụ lý GĐT, TT";
                                        //APS_SOTHAM_THULY objSoTham = dt.APS_SOTHAM_THULY.Where(x => x.DONID == IDVuViec).Single<APS_SOTHAM_THULY>();
                                        //if (objSoTham != null)
                                        //    strNgayVuViec = ((DateTime)objSoTham.NGAYTHULY).ToString("dd/MM/yyyy");
                                        break;
                                    default:
                                        strNgayVuViec = "";
                                        break;

                                }
                                lstTitleNgay.Text = strTieudeNVV;
                                lstNgayvuan.Text = strNgayVuViec;
                                #endregion
                                break;
                            case ENUM_LOAIAN.AN_THA:
                                #region "THA"
                                Decimal IDBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA]);
                                THA_BIAN_BL objBA_BL = new THA_BIAN_BL();
                                try
                                {
                                    DataRow row = objBA_BL.GetInfo(IDBiAn);
                                    lttTitleMaVuAn.Text = "Mã bị án:";
                                    lstMavuan.Text = row["MaBiCan"] + "";

                                    lttTitleVuViec.Text = "Bị án:";
                                    lstTenvuan.Text = row["HoTen"] + "";

                                    lstToaan.Text = row["TenToaAn"] + "";

                                    strNgayVuViec = (String.IsNullOrEmpty(row["NgayThamGia"] + "")) ? "" : (Convert.ToDateTime(row["NgayThamGia"] + "")).ToString("dd/MM/yyyy");
                                    lstTitleNgay.Text = "Ngày tham gia vụ án:";
                                    lstTitleNgay.Text = strNgayVuViec;

                                    LoadBaocao(IDBiAn, 10, 2);
                                }
                                catch (Exception ex) { }
                                #endregion
                                break;
                        }
                        lstTenvuan.Text = Cls_Comon.CatXau(lstTenvuan.Text, 150);
                    }
                }
            }
            catch (Exception ex)
            {

            }
        }
        protected void LoadBaocao(decimal vDonID, decimal LoaiAn, decimal vGiaiDoan)
        {
            hddDonViID.Value = vDonID.ToString();
            hddLoaiAn.Value = LoaiAn.ToString();
            hddGiaidoan.Value = vGiaiDoan.ToString();
            //ADS_DON_BL oBL = new ADS_DON_BL();
            //rptBaocao.DataSource = oBL.ADS_FILE_GETBYDON(vDonID, LoaiAn, vGiaiDoan);
            //rptBaocao.DataBind();
        }
        protected void cmdTrangchu_Click(object sender, EventArgs e)
        {
            string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
            decimal USERID = Convert.ToDecimal(strUserID);

            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == USERID).FirstOrDefault();
            DM_CANBO kiemtra_taikhoan_lanhdao = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID && x.CHUCVUID == 45 && x.CHUCDANHID == 486 && x.HIEULUC == 1).FirstOrDefault();
            if (kiemtra_taikhoan_lanhdao != null)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/BAOCAOCA/Trangchu.aspx");
            }
            else
            {
                Session["MaChuongTrinh"] = "0";
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void lkTaiLieu_Click(object sender, EventArgs e)
        {

        }
        protected void rptMenu_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            switch (e.CommandName)
            {
                case "SELECT":
                    String ND_id = e.CommandArgument.ToString();
                    String[] ND_id_arr = ND_id.Split(';');
                    Session["MaChuongTrinh"] = ND_id_arr[0];
                    if (ND_id_arr[0] == ENUM_LOAIAN.AN_GSTP)
                    {
                        Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Thongtintonghop.aspx");
                    }
                    else if (ND_id_arr[0] == ENUM_LOAIAN.PCTT)
                    {
                        Response.Redirect(Cls_Comon.GetRootURL() + "/PCTP/PhanCongNgauNhien.aspx");
                    }
                    else if (ND_id_arr[0] == "BC_VGDKT")
                    {
                        Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/GDTTT/VuAn/BaoCao/BAOCAO_VGDKT.aspx");
                    }
                    else
                    {
                        Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                    }
                    break;
            }
        }
        protected void cmdThoat_Click(object sender, EventArgs e)
        {
            int so = int.Parse(Application.Get("OnlineNow").ToString());
            if (so > 0) so--;
            else
                so = 0;
            Application.Set("OnlineNow", so);
            // Xóa file js khi hết phiên Logout
            string strFileName_js = "mapdata_" + Session[ENUM_SESSION.SESSION_DONVIID] + ".js";
            string path_js = Server.MapPath("~/GSTP/") + strFileName_js;
            FileInfo oF_js = new FileInfo(path_js);
            if (oF_js.Exists)// Nếu file đã tồn tại
            {
                File.Delete(path_js);
            }
            // Xóa dữ liệu trong session
            Session.Clear();
            Session.Abandon();
            Response.Cookies["ASP.NET_SessionId"].Expires = DateTime.Now.AddDays(-1);
            Response.Cookies["cookiesession1"].Expires = DateTime.Now.AddDays(-1);
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
        protected void lblBack_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
        }
        protected void lbtChangePass_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/ChangePass.aspx");
        }
        protected void cmdTracuu_Click(object sender, EventArgs e)
        {
            string strMCT = Session["MaChuongTrinh"] + "";
            Session["textsearch"] = txtSearch.Text;
            switch (strMCT)
            {
                case ENUM_LOAIAN.AN_HINHSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_DANSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_GDTTT:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/GDTTT/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_THA:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/THA/Danhsach.aspx");
                    break;
            }
        }
        protected void cmdDanhsach_Click(object sender, EventArgs e)
        {
            string strMCT = Session["MaChuongTrinh"] + "";
            switch (strMCT)
            {
                case ENUM_LOAIAN.AN_HINHSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_DANSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_GSTP:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_GDTTT:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/GDTTT/Hoso/Danhsach.aspx");
                    break;
                case ENUM_LOAIAN.AN_THA:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/THA/Danhsach.aspx");
                    break;
            }
        }
        void HuyGhim()
        {
            Decimal IDVuViec = 0;
            decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
            if (oNSD != null)
            {
                string strMCT = Session["MaChuongTrinh"] + "";
                switch (strMCT)
                {
                    case ENUM_LOAIAN.AN_HINHSU:
                        //---huy vu an da ghim 
                        oNSD.IDAHINHSU = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_HINHSU] = IDVuViec;
                        break;
                    case ENUM_LOAIAN.AN_DANSU:
                        //---huy vu an da ghim 
                        oNSD.IDANDANSU = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_DANSU] = IDVuViec;
                        break;
                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        oNSD.IDANHNGD = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = IDVuViec;
                        break;
                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        oNSD.IDANKDTM = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = IDVuViec;
                        break;
                    case ENUM_LOAIAN.AN_LAODONG:
                        oNSD.IDANLAODONG = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_LAODONG] = IDVuViec;
                        break;
                    case ENUM_LOAIAN.AN_HANHCHINH:
                        oNSD.IDANHANHCHINH = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_HANHCHINH] = IDVuViec;

                        break;
                    case ENUM_LOAIAN.AN_PHASAN:
                        oNSD.IDANPHASAN = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_PHASAN] = IDVuViec;

                        break;
                    case ENUM_LOAIAN.BPXLHC:
                        oNSD.IDBPXLHC = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.BPXLHC] = IDVuViec;

                        break;
                    case ENUM_LOAIAN.AN_GDTTT:
                        oNSD.IDGDTTT = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_GDTTT] = IDVuViec;

                        break;
                    case ENUM_LOAIAN.AN_THA:
                        oNSD.IDTHA = IDVuViec;
                        dt.SaveChanges();
                        Session[ENUM_LOAIAN.AN_THA] = IDVuViec;

                        break;
                }
            }
        }
        protected void cmdThemmoi_Click(object sender, EventArgs e)
        {
            HuyGhim();
            Session["DS_THEMDSK"] = null;
            Session["HC_THEMDSK"] = null;
            Session["HN_THEMDSK"] = null;
            Session["KT_THEMDSK"] = null;
            Session["LD_THEMDSK"] = null;
            Session["PS_THEMDSK"] = null;
            Session["XLHC_THEMDSK"] = null;
            Session[ENUM_LOAIAN.AN_DA_KET_THUC] = null;
            string strMCT = Session["MaChuongTrinh"] + "";
            switch (strMCT)
            {
                case ENUM_LOAIAN.AN_HINHSU:
                    //ko doi tham so type = list --> vao man hinh nhap co xu ly thong tin
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Hoso/Thongtinan.aspx?type=list");
                    break;
                case ENUM_LOAIAN.AN_DANSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Hoso/Thongtindon.aspx?type=new");
                    break;
                case ENUM_LOAIAN.AN_GDTTT:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/GDTTT/Hoso/Thongtindon.aspx");
                    break;
                case ENUM_LOAIAN.AN_THA:
                    //ko doi tham so type = list --> vao man hinh nhap co xu ly thong tin
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/THA/Hoso/ThongtinVA.aspx?type=list");
                    break;
            }
        }
        protected void cmdTracuuTP_Click(object sender, EventArgs e)
        {
            DM_CANBO_BL bl = new DM_CANBO_BL();
            string Ten = txtTenTP.Text.Trim();
            decimal DonViLoginID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            DataTable tbl = bl.DM_CANBO_GET_THAMPHAN_TEN_DV(Ten, DonViLoginID, ENUM_DANHMUC.CHUCDANH);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                Ten = ltrTenThamPhan.Text = tbl.Rows[0]["HOTEN"].ToString();
                ltrChucDanh.Text = tbl.Rows[0]["CHUCDANH"].ToString();
                ltrTenToaAn.Text = tbl.Rows[0]["TENTOAAN"].ToString();
                ltrQDBoNhiem.Text = tbl.Rows[0]["QDBONHIEM"].ToString();
                Session[ENUM_LOAIAN.AN_GSTP] = tbl.Rows[0]["ID"].ToString();
                Session["MaChuongTrinh"] = ENUM_LOAIAN.AN_GSTP;
            }
            else
            {
                ltrTenThamPhan.Text = "Chưa chọn thẩm phán!";
                ltrChucDanh.Text = ltrTenToaAn.Text = ltrQDBoNhiem.Text = "";
            }
            Session["TenThamPhan"] = Ten;
            Session["HSC"] = "1";
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/Danhsach.aspx");
        }
        protected void cmdDanhsachAnHuy_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/GSTP/DanhsachAnHuy.aspx");
        }
        protected void btnGSTP_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GSTP").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQLA_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QLA").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnGDT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GDT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTCCB_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TCCB").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnTDKT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TDKT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void btnQTHT_Click(object sender, EventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QTHT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void cmbBack_Click(object sender, EventArgs e)
        {

            Response.Redirect(Cls_Comon.GetRootURL() + "/Launcher.aspx");
        }
        protected void cmdHuyghim_Click(object sender, EventArgs e)
        {
            HuyGhim();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
        }
        protected void cmdTongdat_Click(object sender, EventArgs e)
        {

            string strMCT = Session["MaChuongTrinh"] + "";
            switch (strMCT)
            {
                case ENUM_LOAIAN.AN_HINHSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHS/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_DANSU:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ADS/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHN/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AKT/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/ALD/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/AHC/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/APS/Tongdat.aspx");
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    Response.Redirect(Cls_Comon.GetRootURL() + "/QLAN/XLHC/Tongdat.aspx");
                    break;
            }
        }
        protected void cmdChitiet_Click(object sender, EventArgs e)
        {
            Session["GSTP_CALL_VUAN_INFO"] = null;
            string strMCT = Session["MaChuongTrinh"] + "";
            switch (strMCT)
            {
                case ENUM_LOAIAN.AN_HINHSU:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_AHS")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "Thông tin án hình sự", "CallPopupAHS();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_DANSU:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_ADS")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_ADS", "CallPopupADS();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_AHN")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_AHN", "CallPopupAHN();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_AKT")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_AKT", "CallPopupAKT();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_ALD")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_ALD", "CallPopupALD();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_AHC")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_AHC", "CallPopupAHC();", true);
                    }
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_APS")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_APS", "CallPopupAPS();", true);
                    }
                    break;
                case ENUM_LOAIAN.BPXLHC:
                    if (!(Page.ClientScript.IsStartupScriptRegistered("pThongTin_BPXLHC")))
                    {
                        Page.ClientScript.RegisterStartupScript(Page.GetType(), "pThongTin_BPXLHC", "CallPopupBPXLHC();", true);
                    }
                    break;
            }

        }
        private void LoadGhimThamPhan(decimal ThamPhanID)
        {
            ltrTenThamPhan.Text = ltrChucDanh.Text = ltrQDBoNhiem.Text = ltrTenToaAn.Text = "";
            DM_CANBO cbo = dt.DM_CANBO.Where(x => x.ID == ThamPhanID).FirstOrDefault();
            if (cbo != null)
            {
                ltrTenThamPhan.Text = cbo.HOTEN;
                DM_DATAITEM ChucDanh = dt.DM_DATAITEM.Where(x => x.ID == cbo.CHUCDANHID).FirstOrDefault();
                if (ChucDanh != null)
                {
                    ltrChucDanh.Text = ChucDanh.TEN;
                }
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == cbo.TOAANID).FirstOrDefault();
                if (oTA != null)
                {
                    ltrTenToaAn.Text = oTA.TEN;
                }
                string boNhiem = cbo.NGAYBONHIEM == null ? "" : " ngày " + ((DateTime)cbo.NGAYBONHIEM).ToString("dd/MM/yyyy");
                ltrQDBoNhiem.Text = cbo.QDBONHIEM + boNhiem;

            }
            else
            {
                ltrTenThamPhan.Text = "Chưa chọn thẩm phán!";
            }
        }
        //-----------------------------
        protected void lk_HDSD_Click(object sender, EventArgs e)
        {
            Session["MaChuongTrinh"] = "HDSD_APP";
            Response.Redirect(Cls_Comon.GetRootURL() + "/HDSD/HDSD.aspx");
        }

        //=============================================================================================================================
        #region Khai them
        protected void ExportData(string fileName, string path)
        {
            try
            {
                //copy to MemoryStream
                MemoryStream ms = new MemoryStream();
                using (FileStream fs = File.OpenRead(Path.Combine(path)))
                {
                    fs.CopyTo(ms);
                }

                //Delete file
                if (File.Exists(Path.Combine(path)))
                    File.Delete(Path.Combine(path));

                //Download file
                Response.Clear();
                Response.ContentType = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);
                Response.BinaryWrite(ms.ToArray());
                Response.Flush();
            }
            catch { }

            Response.End();
        }

        private string getTenToa(decimal TOAANID)
        {
            try
            {
                string strTenToa = "Tòa án nhân dân tối cao";
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
            catch { return ""; }
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
            catch { return ""; }
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
            catch { return ""; }
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
            catch { return ""; }
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
            catch { return ""; }
        }

        private string getQuanhephapluat_name(string loaian, string don_st_pt, string tl_ba, decimal DONID)
        {
            string quanhephapluat_name = "";
            if (loaian == "ADS")
            {
                if (don_st_pt == "DON")
                {
                    ADS_DON oT = dt.ADS_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                        ADS_SOTHAM_THULY oND = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        ADS_SOTHAM_BANAN oND = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        ADS_PHUCTHAM_THULY oND = dt.ADS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        ADS_PHUCTHAM_BANAN oND = dt.ADS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            else if (loaian == "AHN")
            {
                if (don_st_pt == "DON")
                {
                    AHN_DON oT = dt.AHN_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                        AHN_SOTHAM_THULY oND = dt.AHN_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AHN_SOTHAM_BANAN oND = dt.AHN_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        AHN_PHUCTHAM_THULY oND = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AHN_PHUCTHAM_BANAN oND = dt.AHN_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            else if (loaian == "AKT")
            {
                if (don_st_pt == "DON")
                {
                    AKT_DON oT = dt.AKT_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                        AKT_SOTHAM_THULY oND = dt.AKT_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AKT_SOTHAM_BANAN oND = dt.AKT_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        AKT_PHUCTHAM_THULY oND = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AKT_PHUCTHAM_BANAN oND = dt.AKT_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            else if (loaian == "ALD")
            {
                if (don_st_pt == "DON")
                {
                    ALD_DON oT = dt.ALD_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                        ALD_SOTHAM_THULY oND = dt.ALD_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        ALD_SOTHAM_BANAN oND = dt.ALD_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        ALD_PHUCTHAM_THULY oND = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        ALD_PHUCTHAM_BANAN oND = dt.ALD_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            else if (loaian == "APS")
            {
                if (don_st_pt == "DON")

                {
                    APS_DON oT = dt.APS_DON.Where(x => x.ID == DONID).FirstOrDefault();
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
                        APS_SOTHAM_THULY oND = dt.APS_SOTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        APS_SOTHAM_BANAN oND = dt.APS_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
                else if (don_st_pt == "PHUCTHAM")
                {
                    if (tl_ba == "THULY")
                    {
                        APS_PHUCTHAM_THULY oND = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        APS_PHUCTHAM_BANAN oND = dt.APS_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            else if (loaian == "AHC")
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
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AHC_SOTHAM_BANAN oND = dt.AHC_SOTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
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
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                    else if (tl_ba == "BANAN")
                    {
                        AHC_PHUCTHAM_BANAN oND = dt.AHC_PHUCTHAM_BANAN.Where(x => x.DONID == DONID).FirstOrDefault();
                        if (oND.QUANHEPHAPLUAT_NAME != null && oND.QUANHEPHAPLUAT_NAME != "")
                        {
                            quanhephapluat_name = oND.QUANHEPHAPLUAT_NAME;
                        }
                        else if (oND.QUANHEPHAPLUATID != null)
                        {
                            quanhephapluat_name = getDataItem(Convert.ToDecimal(oND.QUANHEPHAPLUATID));
                        }
                    }
                }
            }
            return quanhephapluat_name;
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

        public void DownLoadBieuMau()
        {
            decimal vDonID = 0;
            string strMaCT = Session["MaChuongTrinh"] + "";
            switch (strMaCT)
            {
                case ENUM_LOAIAN.AN_DANSU:
                    if (Session[ENUM_LOAIAN.AN_DANSU] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
                        ADS_DON oDon = dt.ADS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportADS(vDonID, oDon);
                    }
                    break;
                case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                    if (Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                        AHN_DON oDonHN = dt.AHN_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportAHN(vDonID, oDonHN);
                    }
                    break;
                case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                    if (Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                        AKT_DON oDonKT = dt.AKT_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportAKT(vDonID, oDonKT);
                    }
                    break;
                case ENUM_LOAIAN.AN_LAODONG:
                    if (Session[ENUM_LOAIAN.AN_LAODONG] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
                        ALD_DON oDonLD = dt.ALD_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportALD(vDonID, oDonLD);
                    }
                    break;
                case ENUM_LOAIAN.AN_PHASAN:
                    if (Session[ENUM_LOAIAN.AN_PHASAN] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                        APS_DON oDonPS = dt.APS_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportAPS(vDonID, oDonPS);
                    }
                    break;
                case ENUM_LOAIAN.AN_HANHCHINH:
                    if (Session[ENUM_LOAIAN.AN_HANHCHINH] != null)
                    {
                        vDonID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                        AHC_DON oDonHC = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
                        LoadReportAHC(vDonID, oDonHC);
                    }
                    break;
            }
        }

        public void LoadReportADS(decimal vDonID, ADS_DON oDon)
        {
            string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
            string strTenToaAn = getTenToa((decimal)oDon.TOAANID);
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string vMaBC = "";
            if (Request["BM"] != null)
                vMaBC = Request["BM"] + "";
            List<ADS_PHUCTHAM_THULY> lstThuLy = dt.ADS_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
            List<ADS_DON_THAMPHAN> lstGQD = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
            List<ADS_DON_DUONGSU> lstND = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
            List<ADS_DON_DUONGSU> lstBD = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<ADS_DON_DUONGSU> lstNVLQ = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<ADS_DON_DUONGSU> lstNDDD = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();

            //Nguyên đơn đại diện
            string strTenQHPL = "";
            string strND_Hoten = "", strND_Diachi = "", strND_Dienthoai = "", strND_Gioitinh = "", strND_Fax = "", strND_Email = "", strND_NoiLamViec = "";//strND_Fax = "", strND_Email = ""

            if (lstNDDD.Count > 0)
            {
                ADS_DON_DUONGSU oNDDD = lstNDDD[0];
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

            //Thông tin bản án/Quyết định kháng cáo, kháng nghị
            string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
            List<ADS_SOTHAM_KHANGCAO> lstkc = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
            List<ADS_SOTHAM_KHANGNGHI> lstkn = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
            string nameKCKN = "";
            if (lstkn.Count > 0)
            {
                nameKCKN = "quyết định kháng nghị";
                //lstkn[0].BANANID
                ADS_SOTHAM_KHANGNGHI oKN = lstkn[0];

                string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-DS ngày " + ngayKN;

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
                strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-DS ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                if (oKN.LOAIKN == 0)//BẢn án
                {
                    strLoaiBAQD = "bản án";
                    List<ADS_SOTHAM_BANAN> lstKNBA = dt.ADS_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
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
                    List<ADS_SOTHAM_QUYETDINH> lstKNBA = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
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
                ADS_SOTHAM_KHANGCAO oKN = lstkc[0];

                strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                if (oKN.DUONGSUID != null)
                {
                    List<ADS_DON_DUONGSU> lstDSKC = dt.ADS_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án dân sự sơ thẩm";
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<ADS_SOTHAM_BANAN> lstKNBA = dt.ADS_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
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
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<ADS_SOTHAM_QUYETDINH> lstKNBA = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                    if (lstKNBA.Count > 0)
                    {
                        strKC_SOBAQD = lstKNBA[0].SOQD;
                        DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                        strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                        strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                        strKC_NamBAQD = oNgayBAQD.Year.ToString();
                    }

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                ADS_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("ADS", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "DS";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}
                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                ADS_DON_DUONGSU ND = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                ADS_DON_DUONGSU BD = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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

                List<ADS_DON_DUONGSU> dsTGTT = dt.ADS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
                string TGTT = "";
                if (dsTGTT != null)
                {
                    foreach (var item in dsTGTT)
                    {
                        TGTT += "\n";
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if(!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if (TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN;
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucTham.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(",", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if(!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { "dân sự" });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
        }

        public void LoadReportAHN(decimal vDonID, AHN_DON oDon)
        {
            string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
            string strTenToaAn = getTenToa((decimal)oDon.TOAANID);
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string vMaBC = "";
            if (Request["BM"] != null)
                vMaBC = Request["BM"] + "";
            List<AHN_PHUCTHAM_THULY> lstThuLy = dt.AHN_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
            List<AHN_DON_THAMPHAN> lstGQD = dt.AHN_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
            List<AHN_DON_DUONGSU> lstND = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
            List<AHN_DON_DUONGSU> lstBD = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<AHN_DON_DUONGSU> lstNVLQ = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<AHN_DON_DUONGSU> lstNDDD = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();

            //Nguyên đơn đại diện
            string strND_Hoten = "", strND_Diachi = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "", strTenQHPL = "";

            if (lstNDDD.Count > 0)
            {
                AHN_DON_DUONGSU oNDDD = lstNDDD[0];
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

            //Thông tin bản án/Quyết định kháng cáo, kháng nghị
            string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
            List<AHN_SOTHAM_KHANGCAO> lstkc = dt.AHN_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
            List<AHN_SOTHAM_KHANGNGHI> lstkn = dt.AHN_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
            string nameKCKN = "";
            if (lstkn.Count > 0)
            {
                nameKCKN = "quyết định kháng nghị";
                //lstkn[0].BANANID
                AHN_SOTHAM_KHANGNGHI oKN = lstkn[0];

                string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-HNGĐ ngày " + ngayKN;

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
                strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-HNGĐ ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                if (oKN.LOAIKN == 0)//BẢn án
                {
                    strLoaiBAQD = "bản án";
                    List<AHN_SOTHAM_BANAN> lstKNBA = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
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
                    List<AHN_SOTHAM_QUYETDINH> lstKNBA = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
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
                AHN_SOTHAM_KHANGCAO oKN = lstkc[0];

                strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                if (oKN.DUONGSUID != null)
                {
                    List<AHN_DON_DUONGSU> lstDSKC = dt.AHN_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án hôn nhân và gia đình sơ thẩm";
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<AHN_SOTHAM_BANAN> lstKNBA = dt.AHN_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
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
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<AHN_SOTHAM_QUYETDINH> lstKNBA = dt.AHN_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                    if (lstKNBA.Count > 0)
                    {
                        strKC_SOBAQD = lstKNBA[0].SOQD;
                        DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                        strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                        strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                        strKC_NamBAQD = oNgayBAQD.Year.ToString();
                    }

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                AHN_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("AHN", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "HNGĐ";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}
                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                AHN_DON_DUONGSU ND = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                AHN_DON_DUONGSU BD = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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

                List<AHN_DON_DUONGSU> dsTGTT = dt.AHN_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
                string TGTT = "";
                if (dsTGTT != null)
                {
                    foreach (var item in dsTGTT)
                    {
                        TGTT += "\n";
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if (!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if (TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN + ".";
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucTham.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(",", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if (!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { "hôn nhân gia đình" });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
        }

        public void LoadReportAKT(decimal vDonID, AKT_DON oDon)
        {
            string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
            string strTenToaAn = getTenToa((decimal)oDon.TOAANID);
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string vMaBC = "";
            if (Request["BM"] != null)
                vMaBC = Request["BM"] + "";
            List<AKT_PHUCTHAM_THULY> lstThuLy = dt.AKT_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
            List<AKT_DON_THAMPHAN> lstGQD = dt.AKT_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
            List<AKT_DON_DUONGSU> lstND = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
            List<AKT_DON_DUONGSU> lstBD = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<AKT_DON_DUONGSU> lstNVLQ = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<AKT_DON_DUONGSU> lstNDDD = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();

            //Nguyên đơn đại diện
            string strND_Hoten = "", strND_Diachi = "", strND_Gioitinh = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "";
            string strTenQHPL = "";

            if (lstNDDD.Count > 0)
            {
                AKT_DON_DUONGSU oNDDD = lstNDDD[0];
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

            //Thông tin bản án/Quyết định kháng cáo, kháng nghị
            string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
            List<AKT_SOTHAM_KHANGCAO> lstkc = dt.AKT_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
            List<AKT_SOTHAM_KHANGNGHI> lstkn = dt.AKT_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
            string nameKCKN = "";
            if (lstkn.Count > 0)
            {
                nameKCKN = "quyết định kháng nghị";
                //lstkn[0].BANANID
                AKT_SOTHAM_KHANGNGHI oKN = lstkn[0];

                string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-KDTM ngày " + ngayKN;

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
                strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-KDTM ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                if (oKN.LOAIKN == 0)//BẢn án
                {
                    strLoaiBAQD = "bản án";
                    List<AKT_SOTHAM_BANAN> lstKNBA = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
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
                    List<AKT_SOTHAM_QUYETDINH> lstKNBA = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
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
                AKT_SOTHAM_KHANGCAO oKN = lstkc[0];

                strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                if (oKN.DUONGSUID != null)
                {
                    List<AKT_DON_DUONGSU> lstDSKC = dt.AKT_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án kinh doanh thương mại sơ thẩm";
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<AKT_SOTHAM_BANAN> lstKNBA = dt.AKT_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
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
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<AKT_SOTHAM_QUYETDINH> lstKNBA = dt.AKT_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                    if (lstKNBA.Count > 0)
                    {
                        strKC_SOBAQD = lstKNBA[0].SOQD;
                        DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                        strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                        strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                        strKC_NamBAQD = oNgayBAQD.Year.ToString();
                    }

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                AKT_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("AKT", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "KDTM";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}
                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                AKT_DON_DUONGSU ND = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                AKT_DON_DUONGSU BD = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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

                List<AKT_DON_DUONGSU> dsTGTT = dt.AKT_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if (!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if (TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN + ".";
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucTham.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(",", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if (!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { "kinh doanh thương mại" });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);

                //objds.DTBM65DS.AddDTBM65DSRow(r);
                //objds.AcceptChanges();
                //rpt65DS rpt = new rpt65DS();
                //rpt.DataSource = objds;
                //rptView.OpenReport(rpt);
            }
        }
        
        public void LoadReportALD(decimal vDonID, ALD_DON oDon)
        {
            string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
            string strTenToaAn = getTenToa((decimal)oDon.TOAANID);
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string vMaBC = "";
            if (Request["BM"] != null)
                vMaBC = Request["BM"] + "";
            List<ALD_PHUCTHAM_THULY> lstThuLy = dt.ALD_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
            List<ALD_DON_THAMPHAN> lstGQD = dt.ALD_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
            List<ALD_DON_DUONGSU> lstND = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
            List<ALD_DON_DUONGSU> lstBD = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<ALD_DON_DUONGSU> lstNVLQ = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<ALD_DON_DUONGSU> lstNDDD = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();

            //Nguyên đơn đại diện
            string strND_Hoten = "", strND_Diachi = "", strND_Gioitinh = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "";
            string strTenQHPL = "";

            if (lstNDDD.Count > 0)
            {
                ALD_DON_DUONGSU oNDDD = lstNDDD[0];
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

            //Thông tin bản án/Quyết định kháng cáo, kháng nghị
            string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
            List<ALD_SOTHAM_KHANGCAO> lstkc = dt.ALD_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
            List<ALD_SOTHAM_KHANGNGHI> lstkn = dt.ALD_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
            string nameKCKN = "";
            if (lstkn.Count > 0)
            {
                nameKCKN = "quyết định kháng nghị";
                //lstkn[0].BANANID
                ALD_SOTHAM_KHANGNGHI oKN = lstkn[0];

                string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-LD ngày " + ngayKN;

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
                strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-LD ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                if (oKN.LOAIKN == 0)//BẢn án
                {
                    strLoaiBAQD = "bản án";
                    List<ALD_SOTHAM_BANAN> lstKNBA = dt.ALD_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
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
                    List<ALD_SOTHAM_QUYETDINH> lstKNBA = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
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
                ALD_SOTHAM_KHANGCAO oKN = lstkc[0];

                strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                if (oKN.DUONGSUID != null)
                {
                    List<ALD_DON_DUONGSU> lstDSKC = dt.ALD_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án lao động sơ thẩm";
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<ALD_SOTHAM_BANAN> lstKNBA = dt.ALD_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
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
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<ALD_SOTHAM_QUYETDINH> lstKNBA = dt.ALD_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                    if (lstKNBA.Count > 0)
                    {
                        strKC_SOBAQD = lstKNBA[0].SOQD;
                        DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                        strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                        strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                        strKC_NamBAQD = oNgayBAQD.Year.ToString();
                    }

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                ALD_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("ALD", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "LD";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}
                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                ALD_DON_DUONGSU ND = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                ALD_DON_DUONGSU BD = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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

                List<ALD_DON_DUONGSU> dsTGTT = dt.ALD_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if (!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if (TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN + ".";
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucTham.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(", ", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if (!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { "lao động" });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
        }

        public void LoadReportAHC(decimal vDonID, AHC_DON oDon)
        {
            //AHC_DON oDon = dt.AHC_DON.Where(x => x.ID == vDonID).FirstOrDefault();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án hành chính sơ thẩm";
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

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                AHC_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("AHC", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "HC";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}

                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                AHC_DON_DUONGSU ND = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                AHC_DON_DUONGSU BD = dt.AHC_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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
                        TGTT += "\n";
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if (!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if (TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN + ".";
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucThamHC.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(", ", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if (!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
        }

        public void LoadReportAPS(decimal vDonID, APS_DON oDon)
        {
            string strDiadiem = getDiaDiem((decimal)oDon.TOAPHUCTHAMID);
            string strTenToaAn = getTenToa((decimal)oDon.TOAANID);
            decimal DonViID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string vMaBC = "";
            if (Request["BM"] != null)
                vMaBC = Request["BM"] + "";
            List<APS_PHUCTHAM_THULY> lstThuLy = dt.APS_PHUCTHAM_THULY.Where(x => x.DONID == vDonID).OrderByDescending(x => x.NGAYTHULY).ToList();
            List<APS_DON_THAMPHAN> lstGQD = dt.APS_DON_THAMPHAN.Where(x => x.DONID == vDonID && x.MAVAITRO == ENUM_VAITROTHAMPHAN.VTTP_GIAIQUYETPHUCTHAM).OrderByDescending(x => x.NGAYPHANCONG).ToList();
            List<APS_DON_DUONGSU> lstND = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON).OrderByDescending(x => x.ISDAIDIEN).ToList();
            List<APS_DON_DUONGSU> lstBD = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.BIDON).ToList();
            List<APS_DON_DUONGSU> lstNVLQ = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.QUYENNVLQ).ToList();
            List<APS_DON_DUONGSU> lstNDDD = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == ENUM_DANSU_TUCACHTOTUNG.NGUYENDON && x.ISDAIDIEN == 1).ToList();

            //Nguyên đơn đại diện
            string strND_Hoten = "", strND_Diachi = "", strND_Gioitinh = "", strND_Dienthoai = "", strND_Fax = "", strND_Email = "";
            string strTenQHPL = "";

            if (lstNDDD.Count > 0)
            {
                APS_DON_DUONGSU oNDDD = lstNDDD[0];
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

            //Thông tin bản án/Quyết định kháng cáo, kháng nghị
            string strKC_Toaan = "", strLoaiKCKN = "", strLoaiBAQD = "", strKC_Nguoi = "", strKC_Diachi = "", strKC_Noidung = "", strKC_SOBAQD = "", strKC_NgayBAQD = "", strKC_ThangBAQD = "", strKC_NamBAQD = "";
            List<APS_SOTHAM_KHANGCAO> lstkc = dt.APS_SOTHAM_KHANGCAO.Where(x => x.DONID == vDonID).ToList();
            List<APS_SOTHAM_KHANGNGHI> lstkn = dt.APS_SOTHAM_KHANGNGHI.Where(x => x.DONID == vDonID).ToList();
            string nameKCKN = "";
            if (lstkn.Count > 0)
            {
                nameKCKN = "quyết định kháng nghị";
                //lstkn[0].BANANID
                APS_SOTHAM_KHANGNGHI oKN = lstkn[0];

                string ngayKN = String.Format("{0:dd/MM/yyyy}", oKN.NGAYKN);
                strLoaiKCKN = "Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-PS ngày " + ngayKN;

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
                strKC_Noidung = "Tại Quyết định kháng nghị số " + oKN.SOKN + "/" + "QĐKNPT-VKS-PS ngày " + ngayKN + " của " + strKC_Nguoi + " kháng nghị " + oKN.NOIDUNGKN;

                if (oKN.LOAIKN == 0)//BẢn án
                {
                    strLoaiBAQD = "bản án";
                    List<APS_SOTHAM_BANAN> lstKNBA = dt.APS_SOTHAM_BANAN.Where(x => x.ID == oKN.BANANID).ToList();
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
                    List<APS_SOTHAM_QUYETDINH> lstKNBA = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == oKN.BANANID).ToList();
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
                APS_SOTHAM_KHANGCAO oKN = lstkc[0];

                strKC_Toaan = getTenToa((decimal)oKN.TOAANRAQDID);
                if (oKN.DUONGSUID != null)
                {
                    List<APS_DON_DUONGSU> lstDSKC = dt.APS_DON_DUONGSU.Where(x => x.ID == oKN.DUONGSUID).ToList();
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
                        if (lstDSKC[0].TAMTRUCHITIET + "" != "")
                        {
                            strKC_Diachi = lstDSKC[0].TAMTRUCHITIET + " " + strKC_Diachi;
                        }
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
                    strKC_Noidung += ". ";
                    string tempStr = strKC_Nguoi.Substring(0, 1).ToUpper();
                    strKC_Nguoi = strKC_Nguoi.Substring(1, strKC_Nguoi.Length - 1);
                    strKC_Nguoi = tempStr + strKC_Nguoi;
                }
                strKC_Noidung += strKC_Nguoi + " kháng cáo " + oKN.NOIDUNGKHANGCAO;

                if (oKN.LOAIKHANGCAO == 0)//BẢn án
                {
                    strLoaiBAQD = "Bản án phá sản sơ thẩm";
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<APS_SOTHAM_BANAN> lstKNBA = dt.APS_SOTHAM_BANAN.Where(x => x.ID == BAKCID).ToList();
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
                    decimal BAKCID = (decimal)oKN.SOQDBA;
                    List<APS_SOTHAM_QUYETDINH> lstKNBA = dt.APS_SOTHAM_QUYETDINH.Where(x => x.ID == BAKCID).ToList();
                    if (lstKNBA.Count > 0)
                    {
                        strKC_SOBAQD = lstKNBA[0].SOQD;
                        DateTime oNgayBAQD = (DateTime)lstKNBA[0].NGAYQD;
                        strKC_NgayBAQD = String.Format("{0:dd}", oNgayBAQD);
                        strKC_ThangBAQD = String.Format("{0:MM}", oNgayBAQD);
                        strKC_NamBAQD = oNgayBAQD.Year.ToString();
                    }

                    Decimal IDQD = Convert.ToDecimal(lstKNBA[0].QUYETDINHID);
                    DM_QD_QUYETDINH tenQD = dt.DM_QD_QUYETDINH.Where(x => x.ID == IDQD).FirstOrDefault();
                    string pattern = @"\(.*?\)";
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(tenQD.TEN, pattern, String.Empty);
                    strLoaiBAQD = System.Text.RegularExpressions.Regex.Replace(strLoaiBAQD, tenQD.MA + ". ", String.Empty);
                    strLoaiBAQD = strLoaiBAQD.Trim();
                }
            }
            if (lstThuLy.Count > 0)
            {
                APS_PHUCTHAM_THULY oSTTL = lstThuLy[0];
                //DM_DATAITEM oTQHPL = dt.DM_DATAITEM.Where(x => x.ID == oSTTL.QUANHEPHAPLUATID).FirstOrDefault();
                //strTenQHPL = oTQHPL.TEN;
                strTenQHPL = getQuanhephapluat_name("APS", "PHUCTHAM", "THULY", Convert.ToDecimal(oSTTL.DONID));

                DTBIEUMAU objds = new DTBIEUMAU();
                DTBIEUMAU.DTBM65DSRow r = objds.DTBM65DS.NewDTBM65DSRow();
                r.DIACHINHAN = "PS";
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
                //if (lstGQD.Count > 0)
                //{
                //    r.TENTHAMPHAN = getCanBo((decimal)lstGQD[0].CANBOID);
                //}
                //else
                //{
                //    r.TENTHAMPHAN = "";
                //}
                //manhnd sua theo yeu cau cau Phuong 8/11/2022 
                //Thu ly Phuc tham xong moi phan Tham phan Giai quyet. Do do khi in thu ly thi lay theo nguoi ky ở Thụ lý
                r.TENTHAMPHAN = getCanBo((decimal)oSTTL.NGUOIKYID);

                APS_DON_DUONGSU ND = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "NGUYENDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                APS_DON_DUONGSU BD = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "BIDON" && x.ISDAIDIEN == 1).FirstOrDefault();
                string nguoiNhanDownload = ND.TENDUONGSU + "_" + BD.TENDUONGSU;
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

                List<APS_DON_DUONGSU> dsTGTT = dt.APS_DON_DUONGSU.Where(x => x.DONID == vDonID && x.TUCACHTOTUNG_MA == "QUYENNVLQ").ToList();
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
                                    TGTT += "- Bà " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Bà " + item.TENDUONGSU + ";";
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
                                    TGTT += "- Ông " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- Ông " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
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
                                    TGTT += "- " + item.TENDUONGSU + strADRESS + ";";
                                }
                                else
                                {
                                    TGTT += "- " + item.TENDUONGSU + ";";
                                }
                            }
                        }
                    }
                }

                if (TGTT.Trim() + "" != "")
                {
                    TGTT = TGTT.Remove(TGTT.Length - 1, 1);
                    TGTT = TGTT + ".";
                }

                if (!vks.TEN.ToLower().Contains("hồ chí minh"))
                {
                    vks.TEN = vks.TEN.Replace("thành phố ", "");
                }

                r.NGUOINHAN = vks.TEN;
                r.NGUOINHAN2 = strND;
                r.NGUOINHAN3 = strBD;
                r.NGUOINHAN4 = TGTT;

                string title4 = "";
                if(TGTT.Trim() + "" != "")
                {
                    title4 = "\n" + "4. Người có quyền lợi, nghĩa vụ liên quan:";
                }

                //r.NGUOINHAN = "1. " + vks.TEN + ".";
                //r.NGUOINHAN2 = "2. Nguyên đơn: " + strND;
                //r.NGUOINHAN3 = "3. Bị đơn: " + strBD;
                //r.NGUOINHAN4 = "4. Người có quyền lợi, nghĩa vụ liên quan:" + TGTT;

                r.NGUOIKHANGCAO = strKC_Nguoi;
                r.DAICHIKHANGCAO = strKC_Diachi;
                r.NOIDUNGKHANGCAO = strKC_Noidung;
                r.STSOBAQD = strKC_SOBAQD;
                r.STNGAYBAQD = strKC_NgayBAQD;
                r.STTHANGBAQD = strKC_ThangBAQD;
                r.STNAMBAQD = strKC_NamBAQD;
                r.STTENTOAAN = strKC_Toaan.Replace("TAND", "Tòa án nhân dân").Replace("\n", "");
                r.NAMEKCKN = nameKCKN;

                r.TENTOAAN = r.TENTOAAN.Replace("\n", "").Replace("TAND", "Tòa án nhân dân");

                //Template new
                string fileName = pathTemplateWord + "rptThongBaoThuLyPhucTham.doc";
                nguoiNhanDownload = nguoiNhanDownload.Replace(", ", "");
                string fileNameSave = "rptThongBaoThuLyPhucTham_" + nguoiNhanDownload + ".doc";
                string saveAs = pathTemplateWord + "rptThongBaoThuLyPhucTham" + Session[ENUM_SESSION.SESSION_USERID] + DateTime.Now.Minute + ".doc";
                Document baoCao = new Document(fileName);
                baoCao.MailMerge.Execute(new[] { "TITLE4" }, new[] { title4 });
                baoCao.MailMerge.Execute(new[] { "TENTOAANHOA" }, new[] { r.TENTOAAN.Replace("tỉnh", "tỉnh \n") });
                baoCao.MailMerge.Execute(new[] { "TENTOAAN" }, new[] { r.TENTOAAN });
                baoCao.MailMerge.Execute(new[] { "SOTHONGBAO" }, new[] { r.SOTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "DIADIEM" }, new[] { r.DIADIEM });
                baoCao.MailMerge.Execute(new[] { "NGAYTHONGBAO" }, new[] { r.NGAYTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "THANGTHONGBAO" }, new[] { r.THANGTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NAMTHONGBAO" }, new[] { r.NAMTHONGBAO });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN" }, new[] { r.NGUOINHAN });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN2" }, new[] { r.NGUOINHAN2 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN3" }, new[] { r.NGUOINHAN3 });
                baoCao.MailMerge.Execute(new[] { "NGUOINHAN4" }, new[] { r.NGUOINHAN4 });
                baoCao.MailMerge.Execute(new[] { "NGAYTHULY" }, new[] { r.NGAYTHULY });
                baoCao.MailMerge.Execute(new[] { "THANGTHULY" }, new[] { r.THANGTHULY });
                baoCao.MailMerge.Execute(new[] { "NAMTHULY" }, new[] { r.NAMTHULY });
                baoCao.MailMerge.Execute(new[] { "SOTHULY" }, new[] { r.SOTHULY });
                string tempKCKN = r.LOAIKCKN.Replace("\n", "");
                if (!tempKCKN.ToLower().Contains("hồ chí minh"))
                {
                    tempKCKN = tempKCKN.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "LOAIKCKN" }, new[] { tempKCKN });
                baoCao.MailMerge.Execute(new[] { "DAICHIKHANGCAO" }, new[] { r.DAICHIKHANGCAO });
                baoCao.MailMerge.Execute(new[] { "LOAIBQQD" }, new[] { r.LOAIBQQD });
                if (!r.LOAIBQQD.ToLower().Contains("bản án"))
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { "QĐ" + r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { "QĐST-" + r.DIACHINHAN });
                }
                else
                {
                    baoCao.MailMerge.Execute(new[] { "DIACHINHAN" }, new[] { r.DIACHINHAN });
                    baoCao.MailMerge.Execute(new[] { "LOAIBAQD" }, new[] { r.DIACHINHAN + "-ST" });
                }
                baoCao.MailMerge.Execute(new[] { "STSOBAQD" }, new[] { r.STSOBAQD });
                baoCao.MailMerge.Execute(new[] { "STNAMBAQD" }, new[] { r.STNAMBAQD });
                baoCao.MailMerge.Execute(new[] { "STNGAYBAQD" }, new[] { r.STNGAYBAQD });
                baoCao.MailMerge.Execute(new[] { "STTHANGBAQD" }, new[] { r.STTHANGBAQD });
                baoCao.MailMerge.Execute(new[] { "STTENTOAAN" }, new[] { r.STTENTOAAN });
                baoCao.MailMerge.Execute(new[] { "NAMEKCKN" }, new[] { r.NAMEKCKN });
                string tempND = r.NOIDUNGKHANGCAO.Replace("\n", "");
                if (!tempND.ToLower().Contains("hồ chí minh"))
                {
                    tempND = tempND.Replace("thành phố ", "");
                }
                baoCao.MailMerge.Execute(new[] { "NOIDUNGKHANGCAO" }, new[] { tempND });
                baoCao.MailMerge.Execute(new[] { "QUANHEPHAPLUAT" }, new[] { r.QUANHEPHAPLUAT });
                baoCao.MailMerge.Execute(new[] { "NGUOIKY" }, new[] { r.TENTHAMPHAN });
                baoCao.MailMerge.Execute(new[] { "LOAIAN" }, new[] { "phá sản" });
                baoCao.Save(saveAs);
                ExportData(fileNameSave, (string)saveAs);
            }
        }

        protected void btnDownLoad_Click(object sender, EventArgs e)
        {
            DownLoadBieuMau();
        }
        #endregion
    }
}