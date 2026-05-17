using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class rpt44HC : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt44HC()
        {
            InitializeComponent();
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }

        private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel4.Text = xrLabel4.Text.ToUpper();
        }

        private void DetailReport_ThamPhan_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_ThamPhan.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_ThamPhan.Visible = false;
                Detail_ThamPhan.Visible = false;
            }
        }

        private void Detail_ttlVKS_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_VKS.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                Detail_ttlVKS.Visible = false;
            }
        }

        private void DetailReport_VKS_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_VKS.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                Detail_listVKS.Visible = false;
            }
        }

        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông ", "");
            xrTableCell36.Text = xrTableCell36.Text.Replace("Bà ", "");
        }
    }
}
