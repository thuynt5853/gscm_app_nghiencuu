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

namespace WEB.GSTP
{
    public partial class Launcher : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected bool hasBietPhai;
        protected string linkTrangchu = "/Trangchu.aspx";

        private void LoadToaAn(decimal ToaAnID)
        {
            hasBietPhai = false;
            DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == ToaAnID).FirstOrDefault();
            //Lay danh sach toa biet phai
            decimal USERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            DM_CANBO_BL cb_BL = new DM_CANBO_BL();
            DataTable dtToaAn = cb_BL.DM_TOAAN_BIETPHAI(USERID);
            DM_TOAAN_BL oBL = new DM_TOAAN_BL();
            if (oT.LOAITOA == "CAPCAO")
            {
                List<DM_TOAAN> tbl = dt.DM_TOAAN.Where(x => x.ID == ToaAnID || x.CAPCHAID == ToaAnID).OrderBy(x => x.ARRTHUTU).ToList();
                ddlDonVi.DataSource = tbl;
                ddlDonVi.DataTextField = "TEN";
                //Them toa biet phai
                if (dtToaAn.Rows.Count > 0)
                {
                    hasBietPhai = true;
                    foreach (DataRow r in dtToaAn.Rows)
                    {
                        DM_TOAAN ta = new DM_TOAAN();
                        ta.ID = Convert.ToDecimal(r["ID"].ToString());
                        ta.TEN = r["TEN"].ToString();
                        tbl.Add(ta);
                    }
                }
            }
            else
            {
                DataTable tbl = oBL.DM_TOAAN_GETBY(ToaAnID);
                ddlDonVi.DataSource = tbl;
                ddlDonVi.DataTextField = "arrTEN";
                //Them toa biet phai
                if (dtToaAn.Rows.Count > 0)
                {
                    hasBietPhai = true;
                    foreach (DataRow r in dtToaAn.Rows)
                    {

                        DataRow dr = tbl.NewRow();
                        dr["arrTEN"] = r["TEN"].ToString();
                        dr["ID"] = r["ID"].ToString();
                        tbl.Rows.Add(dr);
                    }
                }
            }
            ddlDonVi.DataValueField = "ID";
            ddlDonVi.DataBind();
        }
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";

                if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                lstUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                if (!IsPostBack)
                {
                    decimal USERID = Convert.ToDecimal(strUserID);

                    QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == USERID).FirstOrDefault();
                    LoadToaAn(oNSD.DONVIID);
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();

                    DM_CANBO kiemtra_taikhoan_lanhdao = dt.DM_CANBO.Where(x => x.ID == oNSD.CANBOID && x.CHUCVUID == 45 && x.CHUCDANHID == 486 && x.HIEULUC == 1).FirstOrDefault();

                    if (kiemtra_taikhoan_lanhdao != null)
                    {
                        linkTrangchu = "/QLAN/BAOCAOCA/Trangchu.aspx";
                    }

                    DataTable lst;
                    string strSessionKey = "HETHONGGETBY_" + USERID.ToString() ;
                    if (Session[strSessionKey] == null)
                        lst = oBL.QT_HETHONG_GETBYUSER(USERID);
                    else
                        lst = (DataTable)Session[strSessionKey];
                    if (lst.Rows.Count == 1)
                    {
                        Session["MaHeThong"] = lst.Rows[0]["ID"];
                        Session["MaChuongTrinh"] = null;
                        Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
                    }
                    else
                    {
                        foreach (DataRow r in lst.Rows)
                        {
                            switch (r["MA"] + "")
                            {
                                case "GSTP":
                                    btnGSTP.Visible = true;
                                    btnGSTP_dis.Visible = false;
                                    break;
                                case "QLA":
                                    btnQLA.Visible = true;
                                    btnQLA_dis.Visible = false;
                                    break;
                                case "TDKT":
                                    btnTDKT.Visible = true;
                                    btnTDKT_dis.Visible = false;
                                    break;
                                case "BAOCAO":
                                    btnBC.Visible = true;
                                    btnBC_dis.Visible = false;
                                    break;
                                case "QTHT":
                                    btnQTHT.Visible = true;
                                    btnQTHT_dis.Visible = false;
                                    break;
                                case "GDT":
                                    btnGDT.Visible = true;
                                    btnGDT_dis.Visible = false;
                                    break;
                            }
                        }
                    }                   
                    List<DM_TRANGTINH> lstHT = dt.DM_TRANGTINH.Where(x => x.MATRANG == "hotroLaunchergscm").ToList();
                    if (lstHT.Count > 0)
                    {
                        lsthotro.Text = lstHT[0].NOIDUNG;
                    }
                    QT_NHOMNGUOIDUNG oNhom = dt.QT_NHOMNGUOIDUNG.Where(x => x.ID == oNSD.NHOMNSDID).FirstOrDefault();
                    if ((oNhom.LOAI + "") == "1" || hasBietPhai == true) ddlDonVi.Visible = true;
                    else ddlDonVi.Visible = false;
                }
            }
            catch (Exception ex) { }
        }
        protected void cmdThoat_Click(object sender, EventArgs e)
        {
            int so = int.Parse(Application.Get("OnlineNow").ToString());
            if (so > 0) so--;
            else
                so = 0;
            Application.Set("OnlineNow", so);
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }    
        protected void lbtChangePass_Click(object sender, EventArgs e)
        {
            Response.Redirect(Cls_Comon.GetRootURL() + "/ChangePass.aspx");
        }

        private void SetSession()
        {
            decimal TAID = Convert.ToDecimal(ddlDonVi.SelectedValue);
            if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") != ddlDonVi.SelectedValue)
            {
                DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == TAID).FirstOrDefault();
                Session["CAP_XET_XU"] = oTA.LOAITOA;
                Session[ENUM_SESSION.SESSION_DONVIID] = oTA.ID;
                Session[ENUM_SESSION.SESSION_MADONVI] = oTA.MA;
                Session[ENUM_SESSION.SESSION_TENDONVI] = oTA.TEN;

                Session[ENUM_LOAIAN.AN_HINHSU] = null;
                Session[ENUM_LOAIAN.AN_DANSU] = null;
                Session[ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI] = null;
                Session[ENUM_LOAIAN.AN_HONNHAN_GIADINH] = null;
                Session[ENUM_LOAIAN.AN_LAODONG] = null;
                Session[ENUM_LOAIAN.AN_HANHCHINH] = null;
                Session[ENUM_LOAIAN.AN_PHASAN] = null;
                Session[ENUM_LOAIAN.BPXLHC] = null;
                Session[ENUM_LOAIAN.AN_GDTTT] = null;
                Session[ENUM_LOAIAN.AN_THA] = null;
            }
        }
        protected void btnGSTP_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GSTP").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "GSTP";
            SetSession();
            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }

        protected void btnQLA_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QLA").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "QLA";
            SetSession();

            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }

        protected void btnBC_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "BAOCAO").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "BAOCAO";
            SetSession();

            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }

        protected void btnTDKT_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "TDKT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "TDKT";
            SetSession();
            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }

        protected void btnQTHT_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "QTHT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "QTHT";
            SetSession();
            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }

        protected void btnGDT_Click(object sender, ImageClickEventArgs e)
        {
            QT_HETHONG oT = dt.QT_HETHONG.Where(x => x.MA == "GDT").FirstOrDefault();
            Session["MaHeThong"] = oT.ID;
            Session["MaChuongTrinh"] = null;
            Session["MA_HDSD"] = "GDT";
            SetSession();
            Response.Redirect(Cls_Comon.GetRootURL() + linkTrangchu);
        }
    }
}