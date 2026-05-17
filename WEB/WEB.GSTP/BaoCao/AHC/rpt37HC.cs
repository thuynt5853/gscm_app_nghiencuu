using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHC
{
    public partial class rpt37HC : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt37HC()
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

        private void DetailReport_NVLQ_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NVLQ.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                GroupHeader_ttlNVLQ.Visible = false;
                Detail_listNVLQ.Visible = false;
            }
        }

        private void DetailReport_ThamPhan_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_ThamPhan.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_ThamPhan.Visible = false;
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
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_listKSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_VKS.Visible = false;
            }
        }

        private void DetailReport_listKSV_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_listKSV.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport_listKSV.Visible = false;
            }
        }

        private void DetailReport_NguoiTGTT_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport_NguoiTGTT.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                Detail_listNguoiTGTT.Visible = false;
                GroupHeader_ttlNguoiTGTT.Visible = false;
            }
        }
    }
}
