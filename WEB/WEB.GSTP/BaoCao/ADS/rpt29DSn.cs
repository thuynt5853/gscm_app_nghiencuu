using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt29DSn : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt29DSn()
        {
            InitializeComponent();
        }

        private void xrTableCell19_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell19.Text = xrTableCell19.Text.ToUpper();
        }
        private void DeleteEnterTentoaan_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell46.Text = xrTableCell46.Text.Replace("TAND", "Tòa án nhân dân");
            xrTableCell46.Text = xrTableCell46.Text.Replace("\n", ",");
            xrTableCell48.Text = xrTableCell48.Text.Replace("TAND", "Tòa án nhân dân");
            xrTableCell48.Text = xrTableCell48.Text.Replace("\n", ",");
            xrTableCell9.Text = xrTableCell9.Text.Replace("TAND", "Tòa án nhân dân");
            xrTableCell9.Text = xrTableCell9.Text.Replace("THADS", "thi hành án dân sự");
            xrTableCell9.Text = xrTableCell9.Text.Replace("\n", ",");
        }
        private void xrTable8_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("DIACHI") + ""))
            {
                xrTable8.Rows[1].Visible = false;
            }
            if (string.IsNullOrEmpty(GetCurrentColumnValue("NOILAMVIEC") + ""))
            {
                xrTable8.Rows[2].Visible = false;
            }
            if (string.IsNullOrEmpty(GetCurrentColumnValue("SODIENTHOAI") + "") && string.IsNullOrEmpty(GetCurrentColumnValue("FAX") + ""))
            {
                xrTable8.Rows[3].Visible = false;
            }
            if (string.IsNullOrEmpty(GetCurrentColumnValue("EMAIL") + ""))
            {
                xrTable8.Rows[4].Visible = false;
            }
        }
        private void xrTableCell5_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("DIACHI") + ""))
            {
                xrTableRow18.Visible = false;
            }
        }
        private void xrTableCell40_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("NOILAMVIEC") + ""))
            {
                xrTableRow20.Visible = false;
            }
        }
        private void xrTableCell43_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("SODIENTHOAI") + "") && string.IsNullOrEmpty(GetCurrentColumnValue("FAX") + ""))
            {
                xrTableRow31.Visible = false;
            }
        }
        private void xrTableCell44_BeforePrint(object sender, CancelEventArgs e)
        {
            if (string.IsNullOrEmpty(GetCurrentColumnValue("EMAIL") + ""))
            {
                xrTableRow32.Visible = false;
            }
        }
        private void PageFooter_BeforePrint(object sender, CancelEventArgs e)
        {
            e.Cancel = PrintingSystem.PageCount % 2 == 1; //> 0;
        }
        private void PageHeader_BeforePrint(object sender, CancelEventArgs e)
        {
            e.Cancel = PrintingSystem.PageCount % 2 == 1; //> 0;
        }
    }
}
