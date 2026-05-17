using BL.GSTP.BANGSETGET;
using BL.GSTP.BANGSETGET.CONGBOBAQD;
using Module.Common;
using System;

namespace WEB.GSTP.QLAN
{
    public partial class popup_KhongDongY : System.Web.UI.Page
    {
        private BAQD_CONGBO bAQD_CONGBO = new BAQD_CONGBO();

        protected void Page_Load(object sender, EventArgs e)
        {
            string hsID = Request.QueryString["hsID"];
            if (!String.IsNullOrEmpty(hsID))
            {
                try
                {
                    int id = Convert.ToInt32(hsID);
                    this.bAQD_CONGBO = DataExtensions.FindById<BAQD_CONGBO>(id);
                    Console.WriteLine("abc");
                }
                catch { }
            }
        }

        protected void btnLuu_Click(object sender, EventArgs e)
        {
            try
            {
                this.bAQD_CONGBO.TRANGTHAI = 3; //không công bố
                this.bAQD_CONGBO.NGAYSUA = DateTime.Now;
                this.bAQD_CONGBO.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME].ToString();
                DataExtensions.Update<BAQD_CONGBO>(this.bAQD_CONGBO);
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Không công bố/hủy công bố thành công! ");
            }
            catch (Exception ex)
            {
                return;
            }
        }
    }
}