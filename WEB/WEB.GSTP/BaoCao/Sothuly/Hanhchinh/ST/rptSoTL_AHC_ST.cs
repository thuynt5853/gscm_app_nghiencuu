using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.Sothuly.Hanhchinh.ST
{
    public partial class rptSoTL_AHC_ST : DevExpress.XtraReports.UI.XtraReport
    {
        public rptSoTL_AHC_ST()
        {
            InitializeComponent();
        }

        private void xrLabel_TenToaAn_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel_TenToaAn.Text = (Parameters["TenToaAn"].Value + "").ToUpper();
        }

        private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel_TuNgay_DenNgay.Text = "Từ ngày " + Parameters["TuNgay"].Value + " đến ngày " + Parameters["DenNgay"].Value;
        }

        private void xrTableCell_NgayXemSo_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell_NgayXemSo.Text = "Ngày " + string.Format("{0:dd}", DateTime.Today) + " tháng " + string.Format("{0:MM}", DateTime.Today) + " năm " + DateTime.Today.Year;
        }
    }
}
