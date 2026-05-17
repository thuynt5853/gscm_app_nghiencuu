using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class rpt11HS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt11HS()
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
        private void xrTableCell_DieuLuatBS_BeforePrint(object sender, CancelEventArgs e)
        {
            string[] arr = (GetCurrentColumnValue("DIEULUATBOSUNG") + "").Split(';');
            string DieuLuatBS = arr[0];
            xrTableCell_DieuLuatBS.Text = "          Căn cứ các điều 109, 113, 119 và " + DieuLuatBS + " của Bộ luật Tố tụng hình sự;";
        }
        private void xrTable_BienBanNghiAn_BeforePrint(object sender, CancelEventArgs e)
        {
            string[] arr = (GetCurrentColumnValue("DIEULUATBOSUNG") + "").Split(';');
            string DieuLuatBS = arr[0];
            if (DieuLuatBS == "347")// hoàn thành xét xử
            {
                xrTable_BienBanNghiAn.Visible = false;
            }
            else// Điều 358: Điều tra hoặc xét xử lại
            {
                xrTable_BienBanNghiAn.Visible = true;
            }
        }
        private void xrTableCell_XetThay_BeforePrint(object sender, CancelEventArgs e)
        {
            string[] arr = (GetCurrentColumnValue("DIEULUATBOSUNG") + "").Split(';');
            string DieuLuatBS = arr[0], MaKQPT = arr[1];
            if (DieuLuatBS == "347")// hoàn thành xét xử
            {
                if (MaKQPT == "01" || MaKQPT == "02" || MaKQPT == "05")// Giữ hoặc sửa bản án, quyết định sơ thẩm
                    xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm thi hành án.";
                else
                    xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm cho đến khi kết thúc phiên tòa.";
            }
            else// điều tra hoặc xét xử lại
            {
                if(MaKQPT == "14")// Hủy bản án, quyết định sơ thẩm để điều tra lại
                    xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm cho Viện kiểm sát cấp sơ thẩm điều tra lại vụ án.";
                else// Hủy bản án, quyết định sơ thẩm để xét xử lại
                    xrTableCell_XetThay.Text = "          Xét thấy cần thiết tiếp tục tạm giam bị cáo để bảo đảm cho Tòa án cấp sơ thẩm xét xử lại vụ án.";
            }
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
        private void xrTable_XuPhat_ToiDanh_BeforePrint(object sender, CancelEventArgs e)
        {
            string[] arr = (GetCurrentColumnValue("DIEULUATBOSUNG") + "").Split(';');
            string DieuLuatBS = arr[0];
            if (DieuLuatBS == "347")// hoàn thành xét xử
            {
                xrTable_XuPhat_ToiDanh.Visible = true;
            }
            else// Điều 358: Điều tra hoặc xét xử lại
            {
                xrTable_XuPhat_ToiDanh.Visible = false;
            }
        }
        private void xrTableCell_ThoiHanTamGiam_BeforePrint(object sender, CancelEventArgs e)
        {
            string[] arr = (GetCurrentColumnValue("DIEULUATBOSUNG") + "").Split(';');
            string DieuLuatBS = arr[0], MaKQPT = arr[1];
            if (DieuLuatBS == "347")// hoàn thành xét xử
            {
                xrTableCell_ThoiHanTamGiam.Text = "          Thời hạn tạm giam kể từ ngày "+ GetCurrentColumnValue("TUNGAY") + " cho đến khi kết thúc phiên tòa phúc thẩm.";
            }
            else// Điều 358: Điều tra hoặc xét xử lại
            {
                if (MaKQPT == "14")// Hủy bản án, quyết định sơ thẩm để điều tra lại
                    xrTableCell_ThoiHanTamGiam.Text = "          Thời hạn tạm giam tính từ ngày tuyên án cho đến ngày Viện kiểm sát cấp sơ thẩm thụ lý lại vụ án.";
                else// Hủy bản án, quyết định sơ thẩm để xét xử lại
                    xrTableCell_ThoiHanTamGiam.Text = "          Thời hạn tạm giam tính từ ngày tuyên án cho đến ngày Tòa án cấp sơ thẩm thụ lý lại vụ án.";
            }
        }
    }
}
