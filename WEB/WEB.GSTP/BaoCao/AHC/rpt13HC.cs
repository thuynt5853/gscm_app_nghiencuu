using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class rpt13HC : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt13HC()
        {
            InitializeComponent();
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }

        private void DetailReport_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable2.Visible = false;
                xrTable3.Visible = false;
            }
        }

        private void DetailReport1_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport1.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable10.Visible = false;
                xrTable11.Visible = false;
            }
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel4.Text = xrLabel4.Text.ToUpper();
        }

        private void DetailReport5_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport5.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                xrTable13.Visible = false;
                xrTable14.Visible = false;
            }
        }
    }
}
