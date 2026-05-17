using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.HanhChinh
{
    public partial class PL1 : DevExpress.XtraReports.UI.XtraReport
    {
        public PL1()
        {
            InitializeComponent();
        }
        

        private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel_TuNgay_DenNgay.Text = (!String.IsNullOrEmpty(Parameters["DenNgay"].Value + "")) ? (Parameters["DenNgay"].Value + "") : "";
        }

        private void xrLabel1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel1.Text = "" + Parameters["TieuDeBC"].Value;
        }
    }
}
