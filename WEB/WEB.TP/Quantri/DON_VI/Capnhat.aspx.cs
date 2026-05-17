using BL.GSTP;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using WEB.TP.In;
using BL.GSTP.BANGSETGET;
using BL.GSTP.TP_THADS;

namespace WEB.TP.Quantri.DON_VI
{
    public partial class Capnhat : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        protected void Page_Load(object sender, EventArgs e)
        {
            Decimal CurrUser = (string.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
            if (CurrUser == 0)
            {
                Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
            }
            if (!IsPostBack)
            {
                Decimal  Donvi_ID = (String.IsNullOrEmpty(Request["donviID"] + "")) ? 0 : Convert.ToDecimal(Request["donviID"] + "");
                DM_DONVITHIHANHAN oT = dt.DM_DONVITHIHANHAN.Where(x => x.ID == Donvi_ID).FirstOrDefault();
                
                if (oT != null)
                {
                    txt_TEN.Text = oT.TEN;
                    txt_DIACHI.Text = oT.DIACHI;
                    txt_DIENTHOAI.Text = oT.DIENTHOAI;
                    txt_EMAIL.Text = oT.EMAIL;
                    txt_MA_DINH_DANH.Text=oT.MA_DINH_DANH;
                }

                Decimal ID_TT = (String.IsNullOrEmpty(Request["ID_TT"] + "")) ? 0 : Convert.ToDecimal(Request["ID_TT"] + "");
                DM_TK_THANHTOAN ott = dt.DM_TK_THANHTOAN.Where(x => x.ID == ID_TT).FirstOrDefault();
                if (ott != null)
                {
                    txt_TEN_TK_THUHUONG.Text = ott.TEN_TK_THUHUONG;
                   txt_SOTK_KHOBAC .Text= ott.SOTK_KHOBAC;
                    txt_TENTK_KHOBAC.Text = ott.TENTK_KHOBAC;
                    txt_MA_KHOBAC.Text = ott.MA_KHOBAC;
                }

                Decimal ID_LHT = (String.IsNullOrEmpty(Request["ID_LHT"] + "")) ? 0 : Convert.ToDecimal(Request["ID_LHT"] + "");
                DM_LOAIHINH_THU olht = dt.DM_LOAIHINH_THU.Where(x => x.ID == ID_LHT).FirstOrDefault();
                if (olht != null)
                {
                    txt_MALOAIHINHTHU.Text =Convert.ToString(olht.MA);
                    txt_TENLOAIHINHTHU.Text = olht.TEN;

                }

                MenuPermission oPer = QT_TUPHAP_BL.GetMenuPer_THADS(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                Cls_Comon.SetButton(cmdSave, oPer.CAPNHAT);
            }
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            if (CheckValid() == true)
            {
                try
                {
                    string Ten = txt_TEN.Text.Trim();
                    Decimal Donvi_ID = (String.IsNullOrEmpty(Request["donviID"] + "")) ? 0 : Convert.ToDecimal(Request["donviID"] + "");
                    DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == Donvi_ID).FirstOrDefault<DM_DONVITHIHANHAN>();
                    toaAn.DIACHI = txt_DIACHI.Text.Trim();
                    toaAn.DIENTHOAI = txt_DIENTHOAI.Text.Trim();
                    toaAn.EMAIL = txt_EMAIL.Text.Trim();
                    //tam thời đóng lại chưa chp phép cập nhật
                    toaAn.TEN = Ten;
                    toaAn.MA_DINH_DANH = txt_MA_DINH_DANH.Text.Trim();
                    DM_DONVITHIHANHAN toaAnParent = dt.DM_DONVITHIHANHAN.Where(x => x.ID == toaAn.CAPCHAID).FirstOrDefault<DM_DONVITHIHANHAN>();
                    if (toaAnParent == null)
                    {
                        toaAn.MA_TEN = toaAn.TEN;
                    }
                    else
                    {
                        if (toaAn.LOAITOA == "CAPHUYEN" || toaAn.LOAITOA == "QSKHUVUC")
                            toaAn.MA_TEN = toaAn.TEN + "," + toaAnParent.TEN.Replace("Cục Thi hành án", "");
                        else
                            toaAn.MA_TEN = toaAn.TEN;
                    }
                    //---------------------
                    Decimal ID_TT = (String.IsNullOrEmpty(Request["ID_TT"] + "")) ? 0 : Convert.ToDecimal(Request["ID_TT"] + "");
                    DM_TK_THANHTOAN ott = dt.DM_TK_THANHTOAN.Where(x => x.ID == ID_TT).FirstOrDefault<DM_TK_THANHTOAN>();
                    ott.SOTK_KHOBAC = txt_SOTK_KHOBAC.Text.Trim();
                    ott.TENTK_KHOBAC = txt_TENTK_KHOBAC.Text.Trim();
                    ott.MA_KHOBAC = txt_MA_KHOBAC.Text.Trim();
                    ott.TEN_TK_THUHUONG = txt_TEN_TK_THUHUONG.Text.Trim();
                    //----------------
                    //Decimal ID_LHT = (String.IsNullOrEmpty(Request["ID_LHT"] + "")) ? 0 : Convert.ToDecimal(Request["ID_LHT"] + "");
                    //DM_LOAIHINH_THU olht = dt.DM_LOAIHINH_THU.Where(x => x.ID == ID_LHT).FirstOrDefault<DM_LOAIHINH_THU>();

                    //if (txt_MALOAIHINHTHU.Text != "")
                    //{
                    //    olht.MA = Convert.ToDecimal(txt_MALOAIHINHTHU.Text.Trim());
                    //}
                    //olht.TEN = txt_TENLOAIHINHTHU.Text.Trim();
                    //---------------------------
                    dt.SaveChanges();
                    lstMsgB.Text = "Bạn đã cập nhật thành công";
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    //Insert_Tuphap_infor_his
                    TUPHAP_INFOR_HIS o_Object = new TUPHAP_INFOR_HIS();
                    o_Object.DONVI_THA_ID = Donvi_ID;
                    o_Object.USERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    o_Object.TEN_TK_THU_HUONG = txt_TEN_TK_THUHUONG.Text.Trim();
                    o_Object.TEN_DONVI = txt_TEN.Text.Trim();
                    o_Object.DIA_CHI = txt_DIACHI.Text.Trim();
                    o_Object.DIEN_THOAI = txt_DIENTHOAI.Text.Trim();
                    o_Object.EMAIL = txt_EMAIL.Text.Trim();
                    o_Object.MA_DINH_DANH = txt_MA_DINH_DANH.Text.Trim();
                    o_Object.SO_TK = txt_SOTK_KHOBAC.Text.Trim();
                    o_Object.TEN_KHO_BAC = txt_TENTK_KHOBAC.Text.Trim();
                    o_Object.MA_KHO_BAC = txt_MA_KHOBAC.Text.Trim();
                    o_Object.MA_LH_THU = txt_MALOAIHINHTHU.Text;
                    o_Object.TEN_LH_THU = txt_TENLOAIHINHTHU.Text;
                    o_Object.NGUOI_SUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    TUPHAP_INFOR_HIS_BL oBL = new TUPHAP_INFOR_HIS_BL();
                    oBL.TUPHAP_INFOR_HIS_INS(o_Object);
                }
                catch (Exception ex)
                {
                    lstMsgB.Text = "Lỗi: " + ex.Message;
                }
            }
        }
        protected void cmdLichSu_Click(object sender, EventArgs e)
        {
            String dvtha=Request["donviID"] + "";
            string link = "/User_Infor_his.aspx?donviID=" + dvtha + " & userid = " + Session[ENUM_SESSION.SESSION_USERID] + "";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
        }
        private bool CheckValid()
        {
            if (txt_TEN.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập tên đơn vị";
                txt_TEN.Focus();
                return false;
            }
            if (txt_DIACHI.Text == "")
            {
                lstMsgB.Text = "Bạn chưa nhập địa chỉ";
                txt_DIACHI.Focus();
                return false;
            }
            return true;
        }
    }
}