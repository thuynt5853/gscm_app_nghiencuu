using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class rpt07HS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt07HS()
        {
            InitializeComponent();
        }
        private void xrTableCell1_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell1.Text = xrTableCell1.Text.ToUpper();
        }
        private void xrTableCell9_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell9.Text = xrTableCell9.Text.ToUpper();
        }
        private void xrTableCell34_BeforePrint(object sender, CancelEventArgs e)
        {
            xrTableCell34.Text = xrTableCell34.Text.Replace("Ông ", "").Replace("Bà ", "");
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
        private void xrTable_TP_ThanhVien_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("TP_THANHVIEN") + "" == "")
            {
                xrTable_TP_ThanhVien.Visible = false;
            }
            else
            {
                xrTable_TP_ThanhVien.Visible = true;
            }
        }
        private void xrTable_HTND_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("TP_HDND") + "" == "")
            {
                xrTable_HTND.Visible = false;
            }
            else
            {
                xrTable_HTND.Visible = true;
            }
        }
        private void xrTable_BBNGHIAN_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("DIEULUATBOSUNG") + "" == "278")
            {
                xrTable_BBNGHIAN.Visible = false;
            }
            else
            {
                xrTable_BBNGHIAN.Visible = true;
            }
        }
        private void xrTableCell_XetThay_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("DIEULUATBOSUNG") + "" == "278")
            {
                xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm hoàn thành việc xét xử.";
            }
            else
            {
                xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm việc thi hành án.";
            }
        }
        private void xrTableCell_ThoiHanTamGiam_BeforePrint(object sender, CancelEventArgs e)
        {
            if (GetCurrentColumnValue("DIEULUATBOSUNG") + "" == "278")
            {
                xrTableCell_ThoiHanTamGiam.Text = "          Thời hạn tạm giam kể từ ngày " + GetCurrentColumnValue("TUNGAY") + " cho đến khi kết thúc phiên tòa sơ thẩm.";
            }
            else
            {
                xrTableCell_ThoiHanTamGiam.Text = "          Thời hạn tạm giam là: " + GetCurrentColumnValue("THOIHANTAMGIAM") + ", kể từ ngày tuyên án.";
            }
        }
    }
}
