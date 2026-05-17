using DAL.GSTP;
using BL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data;
using System.Text;
using BL.GSTP.BANGSETGET;
using System.Windows.Forms;

namespace WEB.GSTP.Quantri.Nguoidung
{
    public partial class Danhsach : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        public bool GetBool(object obj)
        {
            try
            {
                if ((obj + "") == "")
                    return false;
                else
                    return Convert.ToBoolean(obj);
            }
            catch (Exception ex)
            { return false; }
        }
        Decimal CurrUserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
            if (CurrUserID > 0)
            {
                if (!IsPostBack)
                {
                    LoadCombobox();
                    if (Session["SSND_TA"] != null) ddlDonvi.SelectedValue = Session["SSND_TA"] + "";
                    if (Session["SSND_LN"] != null) ddlLoaiNhom.SelectedValue = Session["SSND_LN"] + "";
                    txtUserName.Text = Session["SSND_US"] + "";
                    txtHoten.Text = Session["SSND_HT"] + "";
                    Load_Data();
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    Cls_Comon.SetButton(cmdThemmoi, oPer.TAOMOI);
                }
            }
            else Response.Redirect("/Login.aspx");
        }

        private void LoadCombobox()
        {
            string strDonViID = Session[ENUM_SESSION.SESSION_DONVIID] + "";
            if (strDonViID != "")
            {
                decimal DonViID = Convert.ToDecimal(strDonViID);
                DM_TOAAN oT = dt.DM_TOAAN.Where(x => x.ID == DonViID).FirstOrDefault();
                if (oT.LOAITOA == "CAPCAO")
                {
                    ddlDonvi.Items.Insert(0, new ListItem(oT.TEN, oT.ID.ToString()));
                }
                else
                {
                    DM_TOAAN_BL oBL = new DM_TOAAN_BL();
                    ddlDonvi.DataSource = oBL.DM_TOAAN_GETBY(DonViID);
                    ddlDonvi.DataTextField = "arrTEN";
                    ddlDonvi.DataValueField = "ID";
                    ddlDonvi.DataBind();
                }
            }
          

        }

        private void Load_Data()
        {
            QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();

            DataTable oDT = oBL.QT_NGUOIDUNG_SEARCH(Convert.ToDecimal(ddlDonvi.SelectedValue), txtDonvi.Text, Convert.ToDecimal(ddlLoaiNhom.SelectedValue), txtUserName.Text, txtHoten.Text);
            if (oDT.Rows.Count > 0)
            {
                #region "Xác định số lượng trang"
                hddTotalPage.Value = Cls_Comon.GetTotalPage(oDT.Rows.Count, 20).ToString();
                lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + oDT.Rows.Count.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                             lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                #endregion
            }
            else
            {
                hddTotalPage.Value = "1";
                Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                           lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
            }

            dgList.DataSource = oDT;
            dgList.DataBind();
           
        }


        protected void lbtimkiem_Click(object sender, EventArgs e)
        {
            Session["SSND_TA"] = ddlDonvi.SelectedValue;
            Session["SSND_LN"] = ddlLoaiNhom.SelectedValue;           
            Session["SSND_US"] = txtUserName.Text;
            Session["SSND_HT"] = txtHoten.Text;
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }


        protected void btnThemmoi_Click(object sender, EventArgs e)
        {

            Response.Redirect("Capnhat.aspx");

        }

        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
           
            switch (e.CommandName)
            { //--------    
                case "Reset":
                    //Response.Redirect("ResetPass.aspx?vID=" + e.CommandArgument.ToString());
                    var OQUANTRI_MATKHAU = DataExtensions.FindById<QUANTRI_MATKHAU>(1);
                    if (OQUANTRI_MATKHAU != null && !string.IsNullOrEmpty(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU))
                    {
                        var userid = Convert.ToDecimal(e.CommandArgument.ToString());
                        QT_NGUOISUDUNG oT = dt.QT_NGUOISUDUNG.Where(x => x.ID == userid).FirstOrDefault();
                        oT.HIEULUC = 1;
                        var repass = RandomPass(int.Parse(OQUANTRI_MATKHAU.DO_DAI_TOI_THIEU));
                        oT.PASSWORD = Cls_Comon.MD5Encrypt(repass);
                        oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                        dt.SaveChanges();

                        //var checkvalidateTK = DataExtensions.FindById<VALIDATE_TAIKHOAN>(userid);
                        //if (checkvalidateTK != null)
                        //{
                        //    checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                        //    checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                        //    checkvalidateTK.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        //    DataExtensions.Update<VALIDATE_TAIKHOAN>(checkvalidateTK);
                        //}
                        //else
                        //{
                            //var OBL = new VALIDATE_TAIKHOAN_BL();
                            //var checkvalidateTK = new VALIDATE_TAIKHOAN();
                            //checkvalidateTK.ID = userid;
                            //checkvalidateTK.NGAY_THAY_DOI_MK = DateTime.Now;
                            //checkvalidateTK.MATKHAU_OLD = oT.PASSWORD;
                            //checkvalidateTK.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            //DataExtensions.Insert<VALIDATE_TAIKHOAN>(checkvalidateTK);
                            //OBL.VALIDATE_TAIKHOAN_INSERT(checkvalidateTK);
                        //}

                        var checkvalidatelog = new VALIDATE_TAIKHOAN_LOG();
                        checkvalidatelog.USER_ID = userid;
                        checkvalidatelog.NGAY_THAY_DOI_MK = DateTime.Now;
                        checkvalidatelog.MATKHAU_OLD = oT.PASSWORD;
                        checkvalidatelog.NGUOI_DOI_MK = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                        checkvalidatelog.NGUOI_DOI_MK_ID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                        DataExtensions.Insert<VALIDATE_TAIKHOAN_LOG>(checkvalidatelog);

                        //ScriptManager.RegisterClientScriptBlock(Page, this.GetType(), "myscript", "alert('Mật khẩu khởi tạo mới là: " + repass + "')", true);
                        lblthongbao.InnerText = "Mật khẩu khởi tạo mới là: " + repass + "";
                        passRS.InnerText = repass;
                        modalDs.Show();
                        Load_Data();
                    }
                    else
                    {
                        Response.Redirect("ResetPass.aspx?vID=" + e.CommandArgument.ToString());
                    }
                    break;
                case "Sua":
                    Response.Redirect("Capnhat.aspx?CID=" + e.CommandArgument.ToString());
                    break;
                case "Xoa":
                    MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));
                    if (oPer.XOA == false)
                    {
                        lbtthongbao.Text = "Bạn không có quyền xóa!";
                        return;
                    }
                    decimal ID = Convert.ToDecimal(e.CommandArgument);
                    QT_NGUOIDUNG_BL oBL = new QT_NGUOIDUNG_BL();

                    var oDT = oBL.GetByID(ID);
                    if (oDT != null)
                    {
                        lbtthongbao.Text = "Tài khoản đang có dữ liệu được sử dụng. Không được phép xóa!";
                        return;
                    }
                    //oBL.DeleteByID(ID);                   
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    Load_Data();
                    break;
            }
        }

        #region "Phân trang"

        private string RandomPass(int length)
        {
            const string valid = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%";
            StringBuilder res = new StringBuilder();
            Random rnd = new Random();
            while (0 < length--)
            {
                res.Append(valid[rnd.Next(valid.Length)]);
            }
            return res.ToString();
        }

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }

        #endregion
    }
}