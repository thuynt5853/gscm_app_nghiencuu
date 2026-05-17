using DAL.GSTP;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI;
using Module.Common.C06;
using System.Text;

namespace WEB.GSTP.QLAN.THA.Hoso.Popup
{
    /* - GTEL-HUNGNQ
       - Mở popup thông tin bị can khi lấy dữ liệu từ API 037 tương tự logic của án Hôn Nhân
       - 30-09-2025 10h:00  */
    public partial class pGetDuongSu037 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0, DuongSuID = 0;
        private const decimal ROOT = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Session["CongDan"] != null)
                {
                    CongDan037 cd = (CongDan037)Session["CongDan"];

                    lblHoTen.Text = cd.HoVaTen.Ten.ToString();
                    DateTime ngaythang;
                    if (cd.NgayThangNam != null)
                    {
                        ngaythang = DateTime.ParseExact(cd.NgayThangNam, "yyyyMMdd", System.Globalization.CultureInfo.InvariantCulture);
                        lblNgaySinh.Text = ngaythang.ToString("dd/MM/yyyy");
                    }
                    else
                    {
                        lblNgaySinh.Text = cd.NamSinh.ToString();
                    }


                    lblCCCD.Text = cd.SoDinhDanh.ToString();
                    lblCMND.Text = cd.SoCMND.ToString();
                    if (cd.GioiTinh == "2")
                    {
                        lblGioiTinh.Text = "Nữ";
                        hdGioiTinhId.Value = "2";
                    }
                    else
                    {
                        lblGioiTinh.Text = "Nam";
                        hdGioiTinhId.Value = "1";
                    }

                    //Noi o hien tai
                    string maTinh = cd.NoiOHienTai.MaTinhThanh;
                    DM_HANHCHINH dmTinh = null;
                    if (maTinh != null)
                    {
                        dmTinh = dt.DM_HANHCHINH.Where(x => x.MA == maTinh && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinh != null)
                        {
                            hdTinhId.Value = dmTinh.ID.ToString();
                            lblTinh.Text = dmTinh.TEN;
                        }

                    }

                    string maXa = cd.NoiOHienTai.MaPhuongXa;
                    DM_HANHCHINH dmHuyen = null;
                    if (maXa != null)
                    {
                        dmHuyen = dt.DM_HANHCHINH.Where(x => x.MA == maXa && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyen != null)
                        {
                            lblHuyen.Text = dmHuyen.TEN;
                            hdXaId.Value = dmHuyen.ID.ToString();
                        }

                    }
                    lblDiaChiChiTiet.Text = cd.NoiOHienTai.ChiTiet.ToString();

                    //Quê quán
                    string maTinh_QQ = cd.QueQuan.MaTinhThanh;
                    DM_HANHCHINH dmTinhQQ = null;
                    if (maTinh_QQ != null)
                    {
                        dmTinhQQ = dt.DM_HANHCHINH.Where(x => x.MA == maTinh_QQ && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinhQQ != null)
                            lblQueQuanTinh.Text = dmTinhQQ.TEN;
                    }

                    string maXaQQ = cd.QueQuan.MaPhuongXa;
                    DM_HANHCHINH dmHuyenQQ = null;
                    if (maXaQQ != null)
                    {
                        dmHuyenQQ = dt.DM_HANHCHINH.Where(x => x.MA == maXaQQ && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyenQQ != null)
                            lblQueQuanXa.Text = dmHuyenQQ.TEN;
                    }
                    lblQueQuanChiTiet.Text = cd.QueQuan.ChiTiet.ToString();

                    //Thường trú
                    string maTinh_TT = cd.ThuongTru.MaTinhThanh;
                    DM_HANHCHINH dmTinhTT = null;
                    if (dmTinhTT != null)
                    {
                        dmTinhTT = dt.DM_HANHCHINH.Where(x => x.MA == maTinh_TT && x.SOCAP == 1 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmTinhTT != null)
                            lblThuongTruTinh.Text = dmTinhTT.TEN;
                    }


                    string maXaTT = cd.ThuongTru.MaPhuongXa;
                    DM_HANHCHINH dmHuyenTT = null;
                    if (dmHuyenTT != null)
                    {
                        dmHuyenTT = dt.DM_HANHCHINH.Where(x => x.MA == maXaTT && x.SOCAP == 2 && x.HIEULUC == 1).FirstOrDefault();
                        if (dmHuyenTT != null)
                            lblThuongTruXa.Text = dmHuyenTT.TEN;
                    }
                    lblThuongTruChiTiet.Text = cd.ThuongTru.ChiTiet.ToString();


                }

            }
        }

        protected void btnLayThongTin_Click(object sender, EventArgs e)
        {
            //Khoi tao doi tuong sẽ lay thong tin
            CongDan037 CongDanLay = new CongDan037();

            CongDanLay.SoCCCD = lblCCCD.Text;
            if (chkHoTen.Checked)
            {
                CongDanLay.HoVaTen.Ten = lblHoTen.Text;
            }

            if (chkCMND.Checked)
            {
                CongDanLay.SoCMND = lblCMND.Text;
            }
            if (chkNgaySinh.Checked)
            {
                CongDanLay.NgayThangNam = lblNgaySinh.Text;
            }

            if (chkGioiTinh.Checked)
            {
                CongDanLay.GioiTinh = hdGioiTinhId.Value;
            }
            if (chkDiaChiChiTiet.Checked)
            {
                CongDanLay.NoiOHienTai.ChiTiet = lblDiaChiChiTiet.Text;
            }
            if (chkDiaChiTinh.Checked)
            {
                CongDanLay.NoiOHienTai.MaTinhThanh = hdTinhId.Value;
                CongDanLay.NoiOHienTai.MaPhuongXa = hdXaId.Value;
            }
            if (chkDiaChiHuyen.Checked)
            {
                CongDanLay.NoiOHienTai.MaTinhThanh = hdTinhId.Value;
                CongDanLay.NoiOHienTai.MaPhuongXa = hdXaId.Value;
            }

            decimal TinhID = Convert.ToDecimal(hdTinhId.Value);
            StringBuilder strHuyen = new StringBuilder();
            List<DM_HANHCHINH> lstHuyen = dt.DM_HANHCHINH.Where(x => x.CAPCHAID == TinhID).OrderBy(x => x.THUTU).ToList<DM_HANHCHINH>();
            if (lstHuyen != null)
            {
                foreach (var item in lstHuyen)
                {
                    if (hdXaId.Value == item.ID.ToString())
                    {
                        strHuyen.Append($@"<option selected=""selected"" value=""{item.MA}"">{item.TEN}</option>");
                    }
                    else
                    {
                        strHuyen.Append($@"<option value=""{item.MA}"">{item.TEN}</option>");
                    }
                }
            }

            // Escape dữ liệu để tránh lỗi khi chèn vào JavaScript
            string hovaten = HttpUtility.JavaScriptStringEncode(CongDanLay.HoVaTen?.Ten ?? "");
            string cccd = HttpUtility.JavaScriptStringEncode(CongDanLay.SoCCCD ?? "");
            string cmnd = HttpUtility.JavaScriptStringEncode(CongDanLay.SoCMND ?? "");
            string gioiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.GioiTinh ?? "");
            string namsinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NgayThangNam ?? "");
            string diachiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaTinhThanh ?? "");
            string diachiHuyen = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaPhuongXa ?? "");
            string diachiChiTiet = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai?.ChiTiet ?? "");
            string hoTenBo = $"{CongDanLay.Cha.HoVaTen.Ho} {CongDanLay.Cha.HoVaTen.ChuDem} {CongDanLay.Cha.HoVaTen.Ten}".Trim();
            string hoTenMe = $"{CongDanLay.Me.HoVaTen.Ho} {CongDanLay.Me.HoVaTen.ChuDem} {CongDanLay.Me.HoVaTen.Ten}".Trim();

            string hoTenBoJS = HttpUtility.JavaScriptStringEncode(hoTenBo);
            string hoTenMeJS = HttpUtility.JavaScriptStringEncode(hoTenMe);

            string caller = Request.QueryString["caller"] ?? "";

            string script = $@"
<script>
(function () {{
    if (!window.opener) {{
        alert('Popup không được mở bằng window.open');
        return;
    }}

    function setText(id, val) {{
        var el = window.opener.document.getElementById(id);
        if (el && val) el.value = val;
    }}

    function setDDL(id, val) {{
        var ddl = window.opener.document.getElementById(id);
        if (!ddl || !val) return;

        ddl.value = val;

        if (window.opener.$ && window.opener.$.fn && window.opener.$.fn.chosen) {{
            window.opener.$('#' + id).trigger('change').trigger('chosen:updated');
        }}
    }}

        setText('txtTennguyendon', '{hovaten}');
        setText('txtSoCCCD', '{cccd}');
        setText('txtSoCMND', '{cmnd}');
        setText('txtNgaySinh', '{namsinh}');
        setText('txtTamtru_Chitiet', '{diachiChiTiet}');
        setDDL('ddlTamTru_Tinh', '{diachiTinh}');

        var hid = window.opener.document.getElementById('hidTamTru_Huyen');
        if(hid) hid.value = '{diachiHuyen}';

        if (window.opener.__doPostBack) {{
            var ddl = window.opener.document.getElementById('ddlTamTru_Huyen');
            if (ddl) {{
                window.opener.__doPostBack(ddl.name, '{diachiTinh}');
            }}
        }}

        window.close();
}})();
</script>";
            ScriptManager.RegisterStartupScript(this, this.GetType(), "ClosePopup", script, false);
        }
    }
}