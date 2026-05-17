using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt38DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt38DS()
        {
            InitializeComponent();
        }
        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông", "").Replace("Bà", "");
        }
        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }
        private void DetailReport_ND_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_ND.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_ND.Visible = false;
                DetailReport_ND.Visible = false;
            }
        }
        private void DetailReport_BD_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_BD.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_BD.Visible = false;
                DetailReport_BD.Visible = false;
            }
        }
        private void DetailReport_NVLQ_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_NVLQ.Visible = false;
                DetailReport_NVLQ.Visible = false;
            }
        }
    }
}
