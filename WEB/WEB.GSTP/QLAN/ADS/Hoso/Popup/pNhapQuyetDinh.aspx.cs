using BL.GSTP;
using BL.GSTP.ADS;
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

namespace WEB.GSTP.QLAN.ADS.Hoso.Popup
{
    public partial class pNhapQuyetDinh : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private const decimal ROOT = 0;
         decimal DonGocID = 0;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                DonGocID = Convert.ToDecimal(Request.QueryString["DonID"].ToString());
                //CheckQuyen(DonID);

            }
        }
       

        
        private bool CheckValid()
        {

            if (Cls_Comon.IsValidDate(txtNgayquyetdinh.Text) == false)
            {
                lbthongbao.Text = "Chưa nhập ngày tuyên án hoặc theo định dạng (dd/MM/yyyy)!";
                txtNgayquyetdinh.Focus();
                return false;
            }
           
              int lengthSQD = txtSoQD.Text.Trim().Length;
            if (lengthSQD == 0)
            {
                lbthongbao.Text = "Bạn chưa nhập số quyết định!";
                txtSoQD.Focus();
                return false;
            }
            return true;
        }





        protected void btnUpdate_Click(object sender, EventArgs e)
        {
            try
            {
                if (!CheckValid()) return;
               
                ADS_PHUCTHAM_BANAN oND = dt.ADS_PHUCTHAM_BANAN.Where(x => x.DONID == DonGocID).FirstOrDefault<ADS_PHUCTHAM_BANAN>();

                oND.NGAYTUYENAN = (String.IsNullOrEmpty(txtNgayquyetdinh.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayquyetdinh.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                dt.ADS_PHUCTHAM_BANAN.Add(oND);
                dt.SaveChanges();
                Cls_Comon.CallFunctionJS(this, this.GetType(), "ReloadParent();");
                lbthongbao.Text = "Lưu thành công!";
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "UpdateRefesh", " window.opener.location.reload();window.close();", true);
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

    }
}