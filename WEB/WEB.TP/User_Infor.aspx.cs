using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Module.Common;
using BL.GSTP.BANGSETGET;
using BL.GSTP.TP_THADS;

namespace WEB.TP
{
    public partial class User_Infor : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                try
                {
                    string strUserID = Session[ENUM_SESSION.SESSION_USERID] + "";
                    if (strUserID == "") Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
                    txtUserName.Text = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                    Load_User_Info();
                    Load_DV();
                }
                catch (Exception ex)
                {
                    { lttMsg.Text = ex.Message; }
                }
            }
        }
        protected void Load_User_Info()
        {
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            txt_HOTEN.Text = oT.HOTEN;
            txt_DIENTHOAI.Text = oT.DIENTHOAI;
            txt_EMAIL.Text = oT.EMAIL;
        }
        protected void Load_DV()
        {
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG nd = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            Decimal Donvi_ID = Convert.ToDecimal(nd.DONVITHA_ID);
            DM_DONVITHIHANHAN oT = dt.DM_DONVITHIHANHAN.Where(x => x.ID == Donvi_ID).FirstOrDefault();

            if (oT != null)
            {
                txt_TEN.Text = oT.TEN;
                txt_DIACHI.Text = oT.DIACHI;
                txt_DIENTHOAI_DV.Text = oT.DIENTHOAI;
                txt_EMAIL_DV.Text = oT.EMAIL;
                txt_MA_DINH_DANH.Text = oT.MA_DINH_DANH;
            }
            DM_TK_THANHTOAN ott = dt.DM_TK_THANHTOAN.Where(x => x.THA_ID == Donvi_ID).FirstOrDefault();
            if (ott != null)
            {
                txt_SOTK_KHOBAC.Text = ott.SOTK_KHOBAC;
                txt_TENTK_KHOBAC.Text = ott.TENTK_KHOBAC;
                txt_MA_KHOBAC.Text = ott.MA_KHOBAC;
                txt_TEN_TK_THUHUONG.Text = ott.TEN_TK_THUHUONG;
                //---------------
                Decimal ID_LHT = Convert.ToDecimal(ott.MA_LOAIHINHTHU);
                DM_LOAIHINH_THU olht = dt.DM_LOAIHINH_THU.Where(x => x.ID == ID_LHT).FirstOrDefault();
                if (olht != null)
                {
                    txt_MALOAIHINHTHU.Text = Convert.ToString(olht.MA);
                    txt_TENLOAIHINHTHU.Text = olht.TEN;
                }
            }
        }
        protected void cmdThoat_Click(object sender, EventArgs e)
        {
            Session.Clear();
            Response.Redirect(Cls_Comon.GetRootURL() + "/Login.aspx");
        }
        protected void cmdSave_Click(object sender, EventArgs e)
        {
            if (txt_HOTEN.Text.Trim() == "")
            {
                lttMsg.Text = "Bạn phải nhập họ tên !";
                return;
            }
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG oT = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            oT.HOTEN = txt_HOTEN.Text;
            oT.DIENTHOAI = txt_DIENTHOAI.Text;
            oT.EMAIL = txt_EMAIL.Text;
            dt.SaveChanges();
            lttMsg.Text = "Bạn đã cập nhật thông tin thành công.";
        }
        protected void cmdSave_dv_Click(object sender, EventArgs e)
        {
            if (CheckValid() == true)
            {
                try
                {
                    string Ten = txt_TEN.Text.Trim();
                    decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    TUPHAP_NGUOISUDUNG nd = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
                    Decimal Donvi_ID = Convert.ToDecimal(nd.DONVITHA_ID);

                    DM_DONVITHIHANHAN toaAn = dt.DM_DONVITHIHANHAN.Where(x => x.ID == Donvi_ID).FirstOrDefault<DM_DONVITHIHANHAN>();
                    toaAn.DIACHI = txt_DIACHI.Text.Trim();
                    toaAn.DIENTHOAI = txt_DIENTHOAI_DV.Text.Trim();
                    toaAn.EMAIL = txt_EMAIL_DV.Text.Trim();
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

                    DM_TK_THANHTOAN ott = dt.DM_TK_THANHTOAN.Where(x => x.THA_ID == Donvi_ID).FirstOrDefault();
                    if (ott != null)
                    {
                        ott.SOTK_KHOBAC = txt_SOTK_KHOBAC.Text.Trim();
                        ott.TENTK_KHOBAC = txt_TENTK_KHOBAC.Text.Trim();
                        ott.MA_KHOBAC = txt_MA_KHOBAC.Text.Trim();
                        ott.TEN_TK_THUHUONG = txt_TEN_TK_THUHUONG.Text.Trim();
                    }
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
                    //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                    //Response.Redirect(HttpContext.Current.Request.Url.ToString(), true);

                    //Insert_Tuphap_infor_his
                    TUPHAP_INFOR_HIS o_Object = new TUPHAP_INFOR_HIS();
                    o_Object.DONVI_THA_ID = Convert.ToDecimal(nd.DONVITHA_ID);
                    o_Object.USERID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                    o_Object.TEN_TK_THU_HUONG = txt_TEN_TK_THUHUONG.Text.Trim();
                    o_Object.TEN_DONVI= txt_TEN.Text.Trim();
                    o_Object.DIA_CHI = txt_DIACHI.Text.Trim();
                    o_Object.DIEN_THOAI = txt_DIENTHOAI_DV.Text.Trim();
                    o_Object.EMAIL = txt_EMAIL_DV.Text.Trim();
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
            decimal current_id = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            TUPHAP_NGUOISUDUNG nd = dt.TUPHAP_NGUOISUDUNG.Where(x => x.ID == current_id).FirstOrDefault();
            string link = "/User_Infor_his.aspx?donviID=" + nd.DONVITHA_ID + " & userid = " + Session[ENUM_SESSION.SESSION_USERID]+"";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "onclick", "var Mleft = (screen.width/2)-(1200/2); var Mtop = (screen.height/2)-(750/2); javascript:window.open('" + link + "', '_blank', 'height=750px,width=1200px,top=\'+Mtop+\', left=\'+Mleft+\',resizable=yes,toolbar=yes,scrollbars=1'); ", true);
        }
         private bool CheckValid()
        {
            String v_mess= "";
            if (txt_TEN_TK_THUHUONG.Text.Trim() == "")
            {
                v_mess = "Bạn chưa nhập Tên tk thụ hưởng.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('"+v_mess+"');", true);
                txt_TEN_TK_THUHUONG.Focus();
                return false;
            }
            if (txt_TEN.Text.Trim() == "")
            {
                v_mess ="Bạn chưa nhập tên đơn vị.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_TEN.Focus();
                return false;
            }
            if (txt_DIACHI.Text.Trim() == "")
            {
                v_mess = "Bạn chưa nhập địa chỉ.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_DIACHI.Focus();
                return false;
            }
            if (txt_DIENTHOAI_DV.Text.Trim() == "")
            {
                v_mess = "Bạn chưa nhập Điện thoại.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_DIENTHOAI_DV.Focus();
                return false;
            }
            if (txt_EMAIL_DV.Text.Trim() == "")
            {
                v_mess = "Bạn chưa nhập Email.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_EMAIL_DV.Focus();
                return false;
            }
            if (txt_MA_DINH_DANH.Text.Trim() == "")
            {
                v_mess ="Bạn chưa nhập Mã định danh.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_MA_DINH_DANH.Focus();
                return false;
            }
            if (txt_SOTK_KHOBAC.Text.Trim() == "")
            {
                v_mess ="Bạn chưa nhập Số TK.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_SOTK_KHOBAC.Focus();
                return false;
            }
            if (txt_TENTK_KHOBAC.Text.Trim() == "")
            {
                v_mess ="Bạn chưa nhập Tên kho bạc.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_TENTK_KHOBAC.Focus();
                return false;
            }
            if (txt_MA_KHOBAC.Text.Trim() == "")
            {
                v_mess ="Bạn chưa nhập Mã CITAD.";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('" + v_mess + "');", true);
                txt_MA_KHOBAC.Focus();
                return false;
            }
            return true;
        }
    }
}