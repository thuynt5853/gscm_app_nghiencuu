using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.UI.WebControls;
using System.Text.RegularExpressions;

namespace WEB.GSTP.UserControl
{
    public partial class MenuLeft : System.Web.UI.UserControl
    {
        private GSTPContext dt = new GSTPContext();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    lstMess.Text = "";
                    string strMaCT = Session["MaChuongTrinh"] + "";
                    if (strMaCT != "" & strMaCT != "0")
                    {
                        //Load tiêu đề
                        QT_CHUONGTRINH oT = dt.QT_CHUONGTRINH.Where(x => x.MA == strMaCT).FirstOrDefault();
                        lstChuongTrinh.Text = oT.TEN;

                        string strIDVUAN = Session[strMaCT] + "";
                        //if ((strIDVUAN == "" || strIDVUAN == "0") && (strMaCT == ENUM_LOAIAN.AN_HINHSU || strMaCT == ENUM_LOAIAN.AN_DANSU || strMaCT == ENUM_LOAIAN.AN_HONNHAN_GIADINH || strMaCT == ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI || strMaCT == ENUM_LOAIAN.AN_LAODONG || strMaCT == ENUM_LOAIAN.AN_HANHCHINH || strMaCT == ENUM_LOAIAN.AN_PHASAN || strMaCT == ENUM_LOAIAN.BPXLHC || strMaCT == ENUM_LOAIAN.AN_GDTTT))
                        //{
                        //    lstMess.Text = "<div class='thongbaochonvuan'>Bạn chưa chọn vụ án để cập nhật thông tin !</div>";
                        //    return;
                        //}

                        //Load menu
                        string strPath = Request.FilePath.ToString().ToLower();
                        if (strPath.Substring(0, 1) == "/")
                            strPath = strPath.Substring(1);

                        List<QT_MENU> lst = dt.QT_MENU.Where(x => x.DUONGDAN.ToLower() == strPath && x.CHUONGTRINHID == oT.ID).ToList();
                        string strArrSapxep = "";
                        if (lst.Count > 0)
                        {
                            strArrSapxep = lst[0].ARRSAPXEP;
                            if (lst[0].ACTION == 1)
                            {
                                decimal IDP = (decimal)lst[0].CAPCHAID;
                                QT_MENU oPr = dt.QT_MENU.Where(x => x.ID == IDP).FirstOrDefault();
                                if (oPr != null) strArrSapxep = oPr.ARRSAPXEP;
                            }
                        }

                        switch (strMaCT)
                        {
                            case ENUM_LOAIAN.AN_DANSU:
                                if ((Session[ENUM_LOAIAN.AN_DANSU] + "") != "" && (Session[ENUM_LOAIAN.AN_DANSU] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_DANSU]);
                                    ADS_DON oDS = dt.ADS_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                        {
                                            decimal gdHoaGiai = oDS.HOAGIAI_TRANGTHAI.GetValueOrDefault(0);
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1, gdHoaGiai);
                                        }
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_GSTP:
                                if ((Session[ENUM_LOAIAN.AN_GSTP] + "") != "" && (Session[ENUM_LOAIAN.AN_GSTP] + "") != "0")
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, -1);
                                break;

                            case ENUM_LOAIAN.AN_HANHCHINH:
                                if ((Session[ENUM_LOAIAN.AN_HANHCHINH] + "") != "" && (Session[ENUM_LOAIAN.AN_HANHCHINH] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HANHCHINH]);
                                    AHC_DON oDS = dt.AHC_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                        {
                                            decimal gdHoaGiai = oDS.HOAGIAI_TRANGTHAI.GetValueOrDefault(0);
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1, gdHoaGiai);
                                        }
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_HINHSU:
                                if ((Session[ENUM_LOAIAN.AN_HINHSU] + "") != "" && (Session[ENUM_LOAIAN.AN_HINHSU] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HINHSU]);

                                    AHS_VUAN oDS = dt.AHS_VUAN.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1);
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                                if ((Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "") != "" && (Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH]);
                                    AHN_DON oDS = dt.AHN_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                        {
                                            decimal gdHoaGiai = oDS.HOAGIAI_TRANGTHAI.GetValueOrDefault(0);
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1, gdHoaGiai);
                                        }
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                                if ((Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "") != "" && (Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI]);
                                    AKT_DON oDS = dt.AKT_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                        {
                                            decimal gdHoaGiai = oDS.HOAGIAI_TRANGTHAI.GetValueOrDefault(0);
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1, gdHoaGiai);
                                        }
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_LAODONG:
                                if ((Session[ENUM_LOAIAN.AN_LAODONG] + "") != "" && (Session[ENUM_LOAIAN.AN_LAODONG] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_LAODONG]);
                                    ALD_DON oDS = dt.ALD_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                        {
                                            decimal gdHoaGiai = oDS.HOAGIAI_TRANGTHAI.GetValueOrDefault(0);
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1, gdHoaGiai);
                                        }
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_PHASAN:
                                if ((Session[ENUM_LOAIAN.AN_PHASAN] + "") != "" && (Session[ENUM_LOAIAN.AN_PHASAN] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_PHASAN]);
                                    APS_DON oDS = dt.APS_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1);
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.BPXLHC:
                                if ((Session[ENUM_LOAIAN.BPXLHC] + "") != "" && (Session[ENUM_LOAIAN.BPXLHC] + "") != "0")
                                {
                                    decimal IDAN = Convert.ToDecimal(Session[ENUM_LOAIAN.BPXLHC]);
                                    XLHC_DON oDS = dt.XLHC_DON.Where(x => x.ID == IDAN).FirstOrDefault();
                                    decimal idToaAn = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == IDAN).FirstOrDefault();
                                    if (oDS != null)
                                    {
                                        if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.HOSO || (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.SOTHAM && oTA != null && oTA.LOAITOA == "CAPHUYEN") || (oDS.TOAANID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString() && oDS.TOAPHUCTHAMID.ToString() != Session[ENUM_SESSION.SESSION_DONVIID].ToString()))
                                            LoadVongdoi(strArrSapxep, (int)oT.ID, 1);
                                        else
                                        {
                                            if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 7);
                                            else if (oDS.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM || oDS.TOAPHUCTHAMID.ToString() == Session[ENUM_SESSION.SESSION_DONVIID].ToString())
                                                LoadVongdoi(strArrSapxep, (int)oT.ID, 2);
                                        }
                                        
                                    }
                                    else
                                    {
                                        LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                    }
                                }
                                else
                                {
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                }
                                break;

                            case ENUM_LOAIAN.AN_GDTTT:
                                if ((Session[ENUM_LOAIAN.AN_GDTTT] + "") != "" && (Session[ENUM_LOAIAN.AN_GDTTT] + "") != "0")
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, -1);
                                else
                                    LoadVongdoi(strArrSapxep, (int)oT.ID, 0);
                                break;

                            default:
                                LoadVongdoi(strArrSapxep, (int)oT.ID, -1);
                                break;
                        }
                    }
                    hddMenuCount.Value = tvOne.Nodes.Count.ToString();
                    tvOne.ExpandAll();
                }
                catch (Exception ex)
                {
                    lblError.Text = "Có lỗi khi hiển thị chức năng !";
                }
            }
        }

        public string LoadVongdoiToXML(int UserID, int ChuongTrinhID, int vGiaidoan, decimal? giaiDoanHG = 0)
        {
            QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();
            string strRootURL = Cls_Comon.GetRootURL();
            string XML = "";
            DataTable oDT;
            if (vGiaidoan == -1)
                oDT = oBL.QT_MENU_GETBYUSER(UserID, ChuongTrinhID);
            else
                oDT = oBL.QT_MENU_GETBYUSER_AN(UserID, ChuongTrinhID, vGiaidoan, giaiDoanHG);

            int sau = 0, truoc = 0;
            int xml_close_menuitem = 0, xml_open_menuitem = 0;

            //string check_menuitem_before = "";
            //string check_menuitem_after = "";

            for (int i = 0; i < oDT.Rows.Count; i++)
            {
                if (i == 0)
                {
                    if ((oDT.Rows[0]["ISPHANNHOM"] + "") == "1")
                        XML = XML + "<menuitem ID='" + oDT.Rows[0]["ARRSAPXEP"] + "'   Text='" + oDT.Rows[0]["TENMENU"] + "' NavigateUrl='" + strRootURL + "/" + oDT.Rows[0]["DUONGDAN"] + "'>";
                    else
                        XML = XML + "<menuitem ID='" + oDT.Rows[0]["ARRSAPXEP"] + "'      Text='" + oDT.Rows[0]["TENMENU"] + "' NavigateUrl=''>";
                }
                else if (i == oDT.Rows.Count - 1)
                {
                    XML = XML + "</menuitem>";

                    if ((oDT.Rows[i]["ISPHANNHOM"] + "") == "1")
                        XML = XML + "<menuitem ID='" + oDT.Rows[i]["ARRSAPXEP"] + "'       Text='" + oDT.Rows[i]["TENMENU"] + "' NavigateUrl='" + strRootURL + "/" + oDT.Rows[i]["DUONGDAN"] + "'>";
                    else
                        XML = XML + "<menuitem ID='" + oDT.Rows[i]["ARRSAPXEP"] + "'      Text='" + oDT.Rows[i]["TENMENU"] + "' NavigateUrl=''>";
                    
                }
                else
                {
                    //check_menuitem_before = oDT.Rows[i - 1]["ARRSAPXEP"].ToString();
                    //check_menuitem_after = oDT.Rows[i]["ARRSAPXEP"].ToString();

                    sau = oDT.Rows[i]["ARRSAPXEP"].ToString().Split('/').Length - 1;
                    truoc = oDT.Rows[i - 1]["ARRSAPXEP"].ToString().Split('/').Length - 1;

                    xml_close_menuitem = Regex.Matches(XML, "</menuitem>").Count;
                    xml_open_menuitem = Regex.Matches(XML, "<menuitem").Count;

                    //Sau bằng trước khi cùng 1 cấp phân hệ
                    if (truoc == sau && xml_close_menuitem < xml_open_menuitem)
                    {
                        XML = XML + "</menuitem>";
                    }

                    xml_close_menuitem = Regex.Matches(XML, "</menuitem>").Count;
                    xml_open_menuitem = Regex.Matches(XML, "<menuitem").Count;

                    if (truoc > sau && xml_close_menuitem < xml_open_menuitem)
                    {
                        for (int j = sau; j <= truoc; j++)
                        {
                            xml_close_menuitem = Regex.Matches(XML, "</menuitem>").Count;
                            xml_open_menuitem = Regex.Matches(XML, "<menuitem").Count;
                            if (xml_close_menuitem != xml_open_menuitem)
                                XML = XML + "</menuitem>";
                        }
                    }

                    if ((oDT.Rows[i]["ISPHANNHOM"] + "") == "1")
                        XML = XML + "<menuitem ID='" + oDT.Rows[i]["ARRSAPXEP"] + "'      Text='" + oDT.Rows[i]["TENMENU"] + "' NavigateUrl='" + strRootURL + "/" + oDT.Rows[i]["DUONGDAN"] + "'>";
                    else
                        XML = XML + "<menuitem ID='" + oDT.Rows[i]["ARRSAPXEP"] + "'     Text='" + oDT.Rows[i]["TENMENU"] + "' NavigateUrl=''>";
                }
            }

            xml_close_menuitem = Regex.Matches(XML, "</menuitem>").Count;
            xml_open_menuitem = Regex.Matches(XML, "<menuitem").Count;

            //Nếu Open nhiều hơn Close thì tự thêm để bằng nhau
            for (int j = xml_close_menuitem; j < xml_open_menuitem; j++)
            {
                XML = XML + "</menuitem>";
            }

            string kq = @"<?xml version=""1.0"" encoding=""UTF-8""?><menucha>" + XML + "</menucha>";
            return kq;
        }

        public void LoadVongdoi(string strPath, int ChuongtrinhID, int vGiaidoan, decimal? giaiDoanHG = 0)
        {
            tvOne.Nodes.Clear();
            string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
            int UserID = 0;
            if (strUserID != "") UserID = Convert.ToInt32(strUserID);
            string strKey = "XMLVongdoi_" + ChuongtrinhID.ToString() + "_" + UserID.ToString() + "_" + vGiaidoan.ToString() + "_" + giaiDoanHG.ToString();
            string strCurrentXMLVD = Session[strKey] + "";
            if (strCurrentXMLVD == "")
            {
                strCurrentXMLVD = LoadVongdoiToXML(UserID, ChuongtrinhID, vGiaidoan, giaiDoanHG);
                Session[strKey] = strCurrentXMLVD;
            }

            XmlDataSource datasource = new XmlDataSource();
            datasource.Data = strCurrentXMLVD;
            datasource.ID = Guid.NewGuid().ToString();
            datasource.XPath = " menucha/menuitem";
            datasource.DataBind();

            tvOne.DataSource = datasource;
            tvOne.DataBind();
            tvOne.CollapseAll();
            //Expand Selected Node
            if (strPath != "")
            {
                foreach (TreeNode oNode in tvOne.Nodes)
                {
                    if (strPath == oNode.Value)
                    {
                        oNode.Selected = true;

                        break;
                    }
                    if (("/" + strPath + "/").Contains("/" + oNode.Value + "/"))
                    {
                        oNode.Expand();
                        SetExpandNode(oNode, strPath);
                        break;
                    }
                    else
                    {
                        oNode.Expand();// oNode.Collapse();
                    }
                }
            }
            else
            {
                foreach (TreeNode oNode in tvOne.Nodes)
                {
                    oNode.Expand();
                }
            }
        }

        public void SetExpandNode(TreeNode root, string strArrVongdoiID)
        {
            foreach (TreeNode oNode in root.ChildNodes)
            {
                if (strArrVongdoiID == oNode.Value)
                {
                    oNode.Selected = true;

                    break;
                }
                if (("/" + strArrVongdoiID + "/").Contains("/" + oNode.Value + "/"))
                {
                    oNode.Expand();
                    SetExpandNode(oNode, strArrVongdoiID);
                    break;
                }
                else
                {
                    oNode.Collapse();
                }
            }
        }

        protected void tvOne_SelectedNodeChanged(object sender, EventArgs e)
        {
            if (tvOne.SelectedNode.Expanded == true)
                tvOne.SelectedNode.Collapse();
            else
                tvOne.SelectedNode.Expand();
        }
    }
}