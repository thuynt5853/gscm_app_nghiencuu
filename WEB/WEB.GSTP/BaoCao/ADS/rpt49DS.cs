using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt49DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt49DS()
        {
            InitializeComponent();
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel4.Text = xrLabel4.Text.ToUpper();
        }

        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông", "").Replace("Bà", "");
        }

        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }

        private void DetailReport_ThamPhan_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_KSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_KSV.Visible = false;
            }
        }

        private void DetailReport_HoiTham_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_HoiTham.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_HoiTham.Visible = false;
            }
        }

        private void DetailReport_VKS_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_KSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_VKS.Visible = false;
            }
        }

        private void DetailReport_KSV_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_KSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_KSV.Visible = false;
            }
        }
    }
}
