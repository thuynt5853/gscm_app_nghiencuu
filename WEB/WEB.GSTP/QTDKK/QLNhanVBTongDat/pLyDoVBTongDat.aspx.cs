using DAL.DKK;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QTDKK.QLNhanVBTongDat
{
    public partial class pLyDoVBTongDat : System.Web.UI.Page
    {
        DKKContextContainer dt = new DKKContextContainer();
        GSTPContext gsdt = new GSTPContext();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request["Id"]!=null)
                {
                    hdddkkuser.Value = Request["Id"] + "";
                }
            }

        }
        private bool Valid()
        {
            if (string.IsNullOrEmpty(txtLyDo.Text))
            {
                lbthongbao.Text = "Vui lòng nhập lý do !";
                lbthongbao.Focus();
                return false;
            }
            return true;
        }
        protected void lbLuu_Click(object sender, EventArgs e)
        {
            lbthongbao.Text = "";
            if (!Valid())
            {
                return;
            }
            if (hddid.Value=="0" || hddid.Value=="")
            {
                //thêm mới
                decimal Id = Convert.ToDecimal(hdddkkuser.Value);
                DONKK_USER_DKNHANVB dkkuser = dt.DONKK_USER_DKNHANVB.FirstOrDefault(x => x.ID == Id);
                dkkuser.TRANGTHAI = 2;
                dt.SaveChanges();

                DKK_LICHSU obj = new DKK_LICHSU();
                obj.DONKKID = dkkuser.DONKKID;
                obj.USERID = dkkuser.USERID;
                obj.NGUOIDUYET_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                obj.LYDO = txtLyDo.Text;
                obj.DONKK_USER_DKNHANVBID = dkkuser.ID;
                dt.DKK_LICHSU.Add(obj);
                dt.SaveChanges();
                hddid.Value = obj.ID + "";
                lbthongbao.Text = "Lưu thành công!";
            }
            else
            {
                //sửa
                decimal Iddkkuser = Convert.ToDecimal(hdddkkuser.Value);
                DONKK_USER_DKNHANVB dkkuser = dt.DONKK_USER_DKNHANVB.FirstOrDefault(x => x.ID == Iddkkuser);

                decimal Id= Convert.ToDecimal(hddid.Value);
                DKK_LICHSU obj = dt.DKK_LICHSU.FirstOrDefault(x => x.ID == Id);
                obj.DONKKID = dkkuser.DONKKID;
                obj.USERID = dkkuser.USERID;
                obj.NGUOIDUYET_ID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                obj.LYDO = txtLyDo.Text;
                obj.DONKK_USER_DKNHANVBID = dkkuser.ID;
                dt.SaveChanges();
                lbthongbao.Text = "Cập nhật thành công!";
            }
            //Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
        //lbQuayLai_Click
        protected void lbQuayLai_Click(object sender, EventArgs e)
        {
            Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();window.close();");
        }
    }
}