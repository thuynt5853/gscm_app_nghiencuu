using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using System.Data;

namespace WEB.GSTP.QLAN.GDTTT.VuAn.BaoCao.HoSo
{
    public partial class mHS : DevExpress.XtraReports.UI.XtraReport
    {
        public mHS()
        {
            InitializeComponent();
        }
        

        //private void xrLabel_TuNgay_DenNgay_BeforePrint(object sender, CancelEventArgs e)
        //{ 
        //    xrLabel_TuNgay_DenNgay.Text = (!String.IsNullOrEmpty(Parameters["ThoiGian"].Value+""))? ( Parameters["ThoiGian"].Value+""): "";
        //}

        private void xrLabel1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrLabel1.Text = "" + Parameters["TieuDeBC"].Value;
        }

        //private void xrLabel2_BeforePrint(object sender, CancelEventArgs e)
        //{
        //    //DataRowView row = (DataRowView)GetCurrentRow();
        //  //  xrLabel2.Text = "Vụ án: " +  ((DataRowView)GetCurrentRow()).Row["TenVuAn"].ToString();
        //   // xrLabel2.Text ="Vụ án: " + GetCurrentColumnValue("TenVuAn") + "";
        //}

        //private void xrLabel3_BeforePrint(object sender, CancelEventArgs e)
        //{
        //    //xrLabel3.Text = "Số thụ lý: " + GetCurrentColumnValue("SoThuLyDon") + "";
        //}

        //private void xrLabel4_BeforePrint(object sender, CancelEventArgs e)
        //{
        //    //xrLabel4.Text = "Ngày thụ lý: " + GetCurrentColumnValue("NgayThuLyDon") + "";
        //}
    }
}
