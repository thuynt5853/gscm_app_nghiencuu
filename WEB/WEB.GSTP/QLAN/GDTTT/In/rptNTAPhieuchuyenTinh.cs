using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.In
{
    public partial class rptNTAPhieuchuyenTinh : DevExpress.XtraReports.UI.XtraReport
    {
        public string strTenTinh = string.Empty;
        public rptNTAPhieuchuyenTinh()
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
            // Xử lý tên tòa án ở đây
            string strTenToa = "TÒA ÁN NHÂN DÂN" + Environment.NewLine + strTenTinh.ToUpper();
            xrTableCell12.Text = strTenToa;
            //xrTableCell12.Text = getTenToa(xrTableCell12.Text.ToUpper());
        }

        private void xrTable3_BeforePrint(object sender, CancelEventArgs e)
        {
            string strLoaiAN = GetCurrentColumnValue("CHIDAO_COKHONG") + "";
            if (strLoaiAN == "1")
            {
                xrTableRow2.Visible = true;
                xrTableRow6.Visible = false;
                xrTableRow5.Visible = true;
            }
            else
            {
                xrTableRow2.Visible = false;
                xrTableRow6.Visible = true;
                xrTableRow5.Visible = false;
            }
            string strND = GetCurrentColumnValue("NOIDUNGCHIDAO") + "";
            if (strND == "") xrTableRow5.Visible = false;
        }

        private void Detail_BeforePrint(object sender, CancelEventArgs e)
        {
            string strLoaiAN = GetCurrentColumnValue("CHIDAO_COKHONG") + "";
            if (strLoaiAN == "1")
            {
                xrTableRow2.Visible = true;
                xrTableRow6.Visible = false;
            }
            else
            {
                xrTableRow2.Visible = false;
                xrTableRow6.Visible = true;
            }
            string strND= GetCurrentColumnValue("NOIDUNGCHIDAO") + "";
            if (strND == "") xrTableRow5.Visible = false;

        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            string strChucvuLD = GetCurrentColumnValue("CHUCVULANHDAO") + "";
            string strLD = GetCurrentColumnValue("LANHDAO") + "";
            string strGTH = GetCurrentColumnValue("GIOITINHHOA") + "";
            string strNG = GetCurrentColumnValue("NGUOIGUI") + "";
            string strNoinhan = "- Như kính gửi;";
            string so = GetCurrentColumnValue("SO") + "";
            if (so.Contains("/TANDTC-VP"))
            {
                if (strChucvuLD.ToLower().Contains("phó"))
                    strNoinhan += "\n- Đ/c Chánh án TANDTC(để b/c);";
                else
                    strNoinhan += "";
                if (strLD == "")
                    strNoinhan += "\n- Đ/c Chánh án TANDTC(để b/c);";
                else
                    strNoinhan += "\n- Đ/c " + strLD + ", " + strChucvuLD + " TANDTC(để b/c);";
                strNoinhan += "\n- Đ/c Chánh Văn phòng TANDTC(để b/c);";

                strNoinhan += "\n- " + strGTH + " " + strNG + " (để biết);";
                strNoinhan += "\n- Lưu: TMTH, HCTP, VPTANDTC.";
            }
            else
            {
                //strNoinhan += "\n- Chánh án TANDCC (để báo cáo);";
                strNoinhan += "\n- Chánh án TAND " + strTenTinh + " (để báo cáo);";
                strNoinhan += "\n- " + strGTH + " " + strNG + " (để biết);";
                strNoinhan += "\n- Lưu: VT, HCTP.";
            }
            xrLabel4.Text = strNoinhan;
        }
    }
}
