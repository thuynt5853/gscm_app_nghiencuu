using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.HoSo
{
    public partial class mMuonHoSoV3 : DevExpress.XtraReports.UI.XtraReport
    {
        public mMuonHoSoV3()
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
            xrTableCell12.Text = getTenToa( xrTableCell12.Text.ToUpper());
        }
               
        private void Detail_BeforePrint(object sender, CancelEventArgs e)
        {
            string strLoaiAN = GetCurrentColumnValue("LOAIAN") + "";
            //if (strLoaiAN == "6")
            //{
            //    xrTable3.Visible = true;
            //    xrTable1.Visible = false;
            //    xrTable4.Visible = false;
            //}
            //else if (strLoaiAN == "1")
            //{
            //    xrTable3.Visible = false;
            //    xrTable1.Visible = true;
            //    xrTable4.Visible = false;
            //}
            //else
            //{
            //    xrTable4.Visible = true;
            //    xrTable3.Visible = false;
            //    xrTable1.Visible = false;
            //}
        }

        private void xrTable1_BeforePrint(object sender, CancelEventArgs e)
        {
            //string strNoidung = GetCurrentColumnValue("DIACHI") + "";
            //if (strNoidung == "")
            //{
            //    xrTableRow21.Visible = false;
            //}
        }

        private void xrTable4_BeforePrint(object sender, CancelEventArgs e)
        {
            //string strNoidung = GetCurrentColumnValue("DIACHI") + "";
            //if (strNoidung == "")
            //{
            //    xrTableRow32.Visible = false;
            //}
        }

        private void xrTable3_BeforePrint(object sender, CancelEventArgs e)
        {
            string strNoidung = GetCurrentColumnValue("DIACHI") + "";
            if (strNoidung == "")
            {
                xrTableRow1.Visible = false;
            }
        }

        private void xrTableCell28_BeforePrint(object sender, CancelEventArgs e)
        {

        }

        private void xrTableCell30_BeforePrint(object sender, CancelEventArgs e)
        {

        }

        private void xrTableCell17_BeforePrint(object sender, CancelEventArgs e)
        {

        }

        private void xrTableCell13_BeforePrint(object sender, CancelEventArgs e)
        {

        }
    }
}
