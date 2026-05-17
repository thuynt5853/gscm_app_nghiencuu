using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.XetXuGDT
{
    public partial class DS : DevExpress.XtraReports.UI.XtraReport
    {
        public DS()
        {
            InitializeComponent();
        }
        

        private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        { 
            xrLabel_TuNgay_DenNgay.Text ="" + Parameters["ThoiGian"].Value;
        }

        private void xrLabel1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel1.Text = "" + Parameters["TieuDeBC"].Value;
        }
    }
}
