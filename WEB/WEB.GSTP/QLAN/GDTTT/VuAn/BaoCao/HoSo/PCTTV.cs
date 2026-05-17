using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.HoSo
{
    public partial class PCTTV : DevExpress.XtraReports.UI.XtraReport
    {
        public PCTTV()
        {
            InitializeComponent();
        }
        

        private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel_TuNgay_DenNgay.Text = (!String.IsNullOrEmpty(Parameters["ThoiGian"].Value + "")) ? (Parameters["ThoiGian"].Value + "") : "";
        }

        private void xrLabel1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel1.Text = "" + Parameters["TieuDeBC"].Value;
        }
    }
}
