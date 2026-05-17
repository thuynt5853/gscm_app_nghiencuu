using System;
using System.Drawing;
using System.Collections;
using System.ComponentModel;
using DevExpress.XtraReports.UI;
using Module.Common;

namespace WEB.GSTP.BaoCao.AHS
{
    public partial class rpt42HS : DevExpress.XtraReports.UI.XtraReport
    {
        public rpt42HS()
        {
            InitializeComponent();
        }

        private void xrTableCell_ThoiHan_BeforePrint(object sender, CancelEventArgs e)
        {
            decimal ThoiGian = Parameters["prmThoiGianGiaHan"].Value + "" == "" ? 0 : Convert.ToDecimal(Parameters["prmThoiGianGiaHan"].Value + "");
            string strThoiGian = Cls_Comon.NumberToTextVN(ThoiGian).Replace(" đồng", ""),
                    SoThuLy = Parameters["prmSoThuLy"].Value + "", NgayHieuLuc = Parameters["prmNgayHieuLuc"].Value + "";
            xrTableCell_ThoiHan.Text = "      Gia hạn thời hạn chuẩn bị xét xử vụ án hình sự sơ thẩm thụ lý số: " + SoThuLy + " là " + ThoiGian.ToString() + " (" + strThoiGian + ") ngày, kể từ " + NgayHieuLuc;
        }
    }
}
