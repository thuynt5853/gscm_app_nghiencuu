using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class rpt60HC : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt60HC()
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

        private void xrTableCell36_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell36.Text = xrTableCell36.Text.Replace("Ông ", "").Replace("Bà ", "");
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

        private void DetailReport_HoiTham_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_HoiTham.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_HoiTham.Visible = false;
                Detail_HoiTham.Visible = false;
            }
        }
    }
}
