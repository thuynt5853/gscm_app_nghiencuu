using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptTradon : DevExpress.XtraReports.UI.XtraReport
    {
        public rptTradon()
        {
            InitializeComponent();
        }
        private string getTenToa(string strTenToa)
        {
            try
            {
                if (strTenToa.Contains("CẤP CAO"))
                {
                    strTenToa = strTenToa.Replace("CẤP CAO", "CẤP CAO\n");
                }

                return strTenToa;
            }
            catch { return ""; }
        }
        private void xrTableCell12_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell12.Text = getTenToa(xrTableCell12.Text.ToUpper());
        }

        private void xrTableCell4_BeforePrint(object sender, CancelEventArgs e)
        {

        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            string strTAND_NHAN = GetCurrentColumnValue("TAND_NHAN") + "";
            string strBIDANH = GetCurrentColumnValue("BIDANH") + "";
            string strNoinhan = "- Như kính gửi;";
            string strTenDonVi = GetCurrentColumnValue("TENDONVI") + "";
            if (strTenDonVi.Contains("Tòa án nhân dân tối cao"))
            {
                
                strNoinhan += "\n- Đ/c Chánh Văn phòng" + strTAND_NHAN + "(để báo cáo);";
                strNoinhan += "\n- Lưu: Văn phòng.\r\n"+ strBIDANH;
            }
            else
            {
                strNoinhan += "\n- Chánh án TANDCC (để báo cáo);";
                strNoinhan += "\n- Lưu: VT, HCTP. (" + strBIDANH +")\r";
            }
            xrLabel4.Text = strNoinhan;
        }

        private void xrTableCell6_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("GIOITINH") + "" == "")
            {
                xrTableCell6.Text = xrTableCell6.Text.Replace("của ", "");
            }

            string strBanan = GetCurrentColumnValue("SOBA") + "";
            if (strBanan.Contains("HC"))
            {
                xrTableCell6.Text = xrTableCell6.Text.Replace("1 Điều 327 của Bộ luật Tố tụng dân sự", "1 Điều 256 của Luật Tố tụng hành chính");
                
            }
        }
        
        private void xrTableCell3_BeforePrint(object sender, CancelEventArgs e)
        {
            string strBanan = GetCurrentColumnValue("SOBA") + "";
            if (strBanan.Contains("HC"))
            {
                xrTableCell3.Text = xrTableCell3.Text.Replace("dân sự", "");
            }
        }
    }
}
