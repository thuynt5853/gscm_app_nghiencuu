using DevExpress.XtraReports.UI;
using System;
using System.Collections;
using System.ComponentModel;
using System.Drawing;

namespace WEB.GSTP.BaoCao.ADS
{
    public partial class rpt49DS_V1 : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt49DS_V1()
        {
            InitializeComponent();
        }
        private void DetailReport_HoiTham1_BeforePrint(object sender, CancelEventArgs e)
        {
            var row = DetailReport.GetCurrentRow() as System.Data.DataRowView;

            bool hasThoiGian = !string.IsNullOrWhiteSpace(row["TENHOITHAM1"]?.ToString());

            // Nếu tất cả đều trống thì ẩn cả block
            if (!hasThoiGian)
            {
                DetailReport.Visible = false;
            }
            else
            {
                DetailReport.Visible = true;  // Hiện tiêu đề
            }
        }
        private void DetailReport_HoiTham_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport1.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport1.Visible = false;
            }
        }
        private void DetailReport_ThuKy_BeforePrint(object sender, CancelEventArgs e)
        {
            var row = DetailReport2.GetCurrentRow() as System.Data.DataRowView;
            var row1 = DetailReport12.GetCurrentRow() as System.Data.DataRowView;

            bool THUKY1 = !string.IsNullOrWhiteSpace(row["THUKY1"]?.ToString());

            // Nếu tất cả đều trống thì ẩn cả block
            if (!THUKY1)
            {
                DetailReport2.Visible = false;
            }
            else
            {
                DetailReport2.Visible = true;  // Hiện tiêu đề
            }  
            if (row1 == null || row1.DataView.Count == 0 || string.IsNullOrWhiteSpace(row1["THUKYPHIENTOA"]?.ToString()))
            {
                DetailReport12.Visible = false;
            }
            else
            {
                DetailReport12.Visible = true;  // Hiện tiêu đề
            }
        }
        private void DetailReport_VKS_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport4.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport3.Visible = false;
            }
        }
        private void DetailReport_KSV_BeforePrint(object sender, CancelEventArgs e)
        {
            System.Data.DataRowView r = (System.Data.DataRowView)DetailReport4.GetCurrentRow();
            if (r == null || r.DataView.Count == 0)
            {
                DetailReport4.Visible = false;
            }
        }
        private void DetailReport_MoPhienToa_BeforePrint(object sender, CancelEventArgs e)
        {
            var row = DetailReport10.GetCurrentRow() as System.Data.DataRowView;
            var row1 = DetailReport11.GetCurrentRow() as System.Data.DataRowView;

            bool hasThoiGian = !string.IsNullOrWhiteSpace(row["THOIGIAN"]?.ToString());
            bool hasNgayMOPT = !string.IsNullOrWhiteSpace(row["NGAYMOPT"]?.ToString());
            bool hasDiaDiem = !string.IsNullOrWhiteSpace(row1["DIADIEMMOPT"]?.ToString());

            // Nếu tất cả đều trống thì ẩn cả block
            if (!hasThoiGian && !hasNgayMOPT && !hasDiaDiem)
            {
                DetailReport8.Visible = false;
                DetailReport10.Visible = false;
                DetailReport11.Visible = false; 
            }
            else
            {
                DetailReport8.Visible = true;  // Hiện tiêu đề
                DetailReport10.Visible = (hasThoiGian || hasNgayMOPT);
                DetailReport11.Visible = hasDiaDiem;                   
            }
        }

    }
}
