using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using System.Data;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.HoSo
{
    public partial class HS : DevExpress.XtraReports.UI.XtraReport
    {
        public HS()
        {
            InitializeComponent();
        }
        

        private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        { 
            xrLabel_TuNgay_DenNgay.Text = (!String.IsNullOrEmpty(Parameters["ThoiGian"].Value+""))? ( Parameters["ThoiGian"].Value+""): "";
        }

        private void xrLabel1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel1.Text = "" + Parameters["TieuDeBC"].Value;
        }

        private void xrLabel2_BeforePrint(object sender, CancelEventArgs e)
        {
            //xrLabel2.Text = "Vụ án: ";
        }
        private void xrLabel11_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel11.Text = "" + Parameters["TenVuAn"].Value;
        }

        private void xrLabel3_BeforePrint(object sender, CancelEventArgs e)
        {
            //xrLabel3.Text = "" + Parameters["SoThuLy"].Value + "";
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
           //xrLabel4.Text = "" + Parameters["NgayThuLy"].Value + "";
        }

        private void xrLabel7_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel7.Text = "" + Parameters["SoThuLy"].Value + "";
        }

        private void xrLabel8_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel8.Text = "" + Parameters["NgayThuLy"].Value + "";
        }
        private void xrLabel9_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel9.Text = "" + Parameters["SoBanAn"].Value + "";
        }

        private void xrLabel10_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel10.Text = "" + Parameters["NgayBanAn"].Value + "";
        }
    }
}
