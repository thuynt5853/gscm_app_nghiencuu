using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt45DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt45DS()
        {
            InitializeComponent();
        }

        private void DetailReport2_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport2.GetCurrentRow();

            if (r == null || r.DataView.Count == 0)
            {
                xrTable7.Visible = false;
                xrTable5.Visible = false;
            }
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }
    }
}
