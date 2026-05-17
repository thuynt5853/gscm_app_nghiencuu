using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class rpt04HS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt04HS()
        {
            InitializeComponent();
        }
        private void xrTable_BC_HT_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" != "0")// không phải cá nhân
            {
                xrTable_BC_HT.Visible = false;
            }
            else
            {
                xrTable_BC_HT.Visible = true;
            }
        }
        private void xrTable_BC_DC_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" != "0")// không phải cá nhân
            {
                xrTable_BC_DC.Visible = false;
            }
            else
            {
                xrTable_BC_DC.Visible = true;
            }
        }
        private void xrTable_BC_NN_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" != "0")// không phải cá nhân
            {
                xrTable_BC_NN.Visible = false;
            }
            else
            {
                if (string.IsNullOrEmpty(GetCurrentColumnValue("BICAN_NGHENGHIEP") + ""))
                { xrTable_BC_NN.Visible = false; }
                else { xrTable_BC_NN.Visible = true; }
            }
        }
        private void xrTable_PNTM_Ten_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" == "0")// Cá nhân
            { xrTable_PNTM_Ten.Visible = false; }
            else { xrTable_PNTM_Ten.Visible = true; }
        }
        private void xrTable_PNTM_DC_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" == "0")// Cá nhân
            { xrTable_PNTM_DC.Visible = false; }
            else { xrTable_PNTM_DC.Visible = true; }
        }
        private void xrTable_PNTM_NDD_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("LOAIDOITUONG") + "" == "0")// Cá nhân
            { xrTable_PNTM_NDD.Visible = false; }
            else if (string.IsNullOrEmpty(GetCurrentColumnValue("BICAN_TENKHAC") + ""))
            { xrTable_PNTM_NDD.Visible = false; }
            else { xrTable_PNTM_NDD.Visible = true; }
        }
        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }
        private void xrTableCell9_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell9.Text = xrTableCell9.Text.ToUpper();
            xrTableCell9.Text = xrTableCell9.Text.Replace("TÒA ÁN NHÂN DÂN\n", "TÒA ÁN NHÂN DÂN");
        }
        private void xrTableCell_NoiNhanThiHanh_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell_NoiNhanThiHanh.Text = "- Cơ sở giam giữ, " + GetCurrentColumnValue("ISBICAN") + ";";
        }
        private void xrTableCell20_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell20.Text = xrTableCell20.Text.ToUpper();
        }
    }
}
