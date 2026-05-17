using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt81DS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt81DS()
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
        private void xrTableCell4_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell4.Text = xrTableCell4.Text.ToUpper();
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
        private void xrTableCell_NguoiKC_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("NGUOIKCKN") + ""))
            {
                xrTableCell_NguoiKC.Visible = false;
            }
        }
        private void xrTableCell_DCKC_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("NGUOIKCKN") + ""))
            {
                xrTableCell_DCKC.Visible = false;
            }
        }
        private void SubBand_VKSKN_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("VKSKHANGNGHI") + ""))
            {
                SubBand_VKSKN.Visible = false;
            }
        }
    }
}
