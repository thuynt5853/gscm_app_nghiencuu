using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.Thongke
{
    public partial class rptThongkeChitieu : DevExpress.XtraReports.UI.XtraReport
    {
        public rptThongkeChitieu()
        {
            InitializeComponent();
        }

        private void xrTableCell25_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell25.Text = Parameters["TenPhongban"].Value.ToString().ToUpper() + "";
        }

        private void xrTableCell14_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell14.Text = "(Từ ngày " + Parameters["TuNgay"].Value + " đến ngày " + Parameters["DenNgay"].Value + ")";
        }
    }
}
