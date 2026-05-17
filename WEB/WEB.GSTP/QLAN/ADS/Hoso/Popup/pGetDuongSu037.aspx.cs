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

namespace WEB.GSTP.QLAN.ADS.Hoso.Popup
{
    /* - GTEL-HUNGNQ
       - Mở popup thông tin bị can khi lấy dữ liệu từ API 037 tương tự logic của án Hôn Nhân
       - 30-09-2025 10h:00  */
    public partial class pGetDuongSu037 : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal DonID = 0,DuongSuID = 0;
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
                    else {
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
                        dmTinh = dt.DM_HANHCHINH.Where(x => x.MA == maTinh && x.SOCAP == 1 &&x.HIEULUC == 1).FirstOrDefault();
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
            string cmnd = HttpUtility.JavaScriptStringEncode(CongDanLay.SoCMND ?? "");
            string gioiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.GioiTinh ?? "");
            string namsinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NgayThangNam ?? "");
            string diachiTinh = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaTinhThanh ?? "");
            string diachiHuyen = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai.MaPhuongXa ?? "");
            string diachiChiTiet = HttpUtility.JavaScriptStringEncode(CongDanLay.NoiOHienTai?.ChiTiet ?? "");

            string caller = Request.QueryString["caller"] ?? "";
            string script = $@"
                            <script type='text/javascript'>
                                try {{
                                    if (window.opener && !window.opener.closed) {{
                                        var caller = '{caller}';

                                        function setTextbox(id, val) {{
                                            if (val && val.trim() !== '') {{
                                                var txt = window.opener.document.getElementById(id);
                                                if (txt) txt.value = val;
                                            }}
                                        }}

                                        function setDropdown(id, val) {{
                                            if (val && val.trim() !== '') {{
                                                var ddl = window.opener.document.getElementById(id);
                                                if (ddl) {{
                                                    ddl.value = val;
                                                    if (window.opener.$) {{
                                                         window.opener.$('#' + id).trigger('change').trigger('chosen:updated');
                                                    }}
                                                }}
                                            }}
                                        }}

                                        function setDropdownByOptions(id, options) {{
                                            var ddl = window.opener.document.getElementById(id);
                                            if (ddl) {{
                                                ddl.innerHTML = options;
                                                if (window.opener.$) {{
                                                        window.opener.$('#' + id).trigger('change').trigger('chosen:updated');
                                                }}
                                            }}
                                        }}

                                        setDropdown('ddlNoiSongTinh', '{diachiTinh}');
                                        setDropdown('ddlNoiSongHuyen', '{diachiHuyen}');

                                        if (caller === 'DuongSu') {{
                                            setTextbox('txtTennguyendon', '{hovaten}');
                                            setTextbox('txtND_CMND', '{cmnd}');
                                            setTextbox('txtND_TTChitiet', '{diachiChiTiet}');
                                            setTextbox('txtND_Ngaysinh', '{namsinh}');
                                            setDropdown('ddlND_Gioitinh', '{gioiTinh}');
                                            

                                            // Set tỉnh
                                            setDropdown('ddlNoiSongTinh', '{diachiTinh}');
                                            // Ghi huyện vào HiddenField
                                            var hid = window.opener.document.getElementById('hidNoiSongHuyen');
                                            if(hid) hid.value = '{diachiHuyen}';
                                            
                                            // Set tỉnh
                                            //setDropdownByOptions('ddlNoiSongHuyen', '{strHuyen}');

                                            // Gọi postback để load huyện từ server
                                            if (window.opener.__doPostBack) {{
                                                var ddl = window.opener.document.getElementById('ddlNoiSongTinh');
                                                if (ddl) {{
                                                    window.opener.__doPostBack(ddl.name, '{diachiTinh}');
                                                }}
                                            }}
                                        }}
                                        else if (caller === 'DuongSuND') {{
                                            setTextbox('txtTennguyendon', '{hovaten}');
                                            setTextbox('txtND_CMND', '{cmnd}');
                                            setTextbox('txtND_TTChitiet', '{diachiChiTiet}');
                                            setTextbox('txtND_Ngaysinh', '{namsinh}');
                                            setDropdown('ddlND_Gioitinh', '{gioiTinh}');

                                            setDropdown('ddlTamTru_Tinh_NguyenDon', '{diachiTinh}');
                                            var hid = window.opener.document.getElementById('hidTamTru_Huyen_NguyenDon');
                                            if(hid) hid.value = '{diachiHuyen}';

                                            // Set tỉnh
                                            //setDropdownByOptions('ddlTamTru_Huyen_NguyenDon', '{strHuyen}');
                                            // Gọi postback để load huyện từ server
                                            if (window.opener.__doPostBack) {{
                                                var ddl = window.opener.document.getElementById('ddlTamTru_Huyen_NguyenDon');
                                                if (ddl) {{
                                                    window.opener.__doPostBack(ddl.name, '{diachiTinh}');
                                                }}
                                            }}
                                        }}
                                        else if (caller === 'DuongSuBD') {{
                                            setTextbox('txtBD_Ten', '{hovaten}');
                                            setTextbox('txtBD_CMND', '{cmnd}');
                                            setTextbox('txtBD_Tamtru_Chitiet', '{diachiChiTiet}');
                                            setTextbox('txtBD_Ngaysinh', '{namsinh}');
                                            setDropdown('ddlBD_Gioitinh', '{gioiTinh}');

                                            setDropdown('ddlTamTru_Tinh_BiDon', '{diachiTinh}');
                                            var hid = window.opener.document.getElementById('hidTamTru_Huyen_BiDon');
                                            if(hid) hid.value = '{diachiHuyen}';

                                            // Set tỉnh
                                            //setDropdownByOptions('ddlTamTru_Huyen_BiDon', '{strHuyen}');
                                            // Gọi postback để load huyện từ server
                                            if (window.opener.__doPostBack) {{
                                                var ddl = window.opener.document.getElementById('ddlTamTru_Huyen_BiDon');
                                                if (ddl) {{
                                                    window.opener.__doPostBack(ddl.name, '{diachiTinh}');
                                                }}
                                            }}
                                        }}
                                        else {{
                                            alert('Không xác định form gọi');
                                        }}
                                    }} else {{
                                        console.log('Không tìm thấy form chính');
                                    }}
                                }} catch (ex) {{
                                    alert('Lỗi truyền dữ liệu: ' + ex.message);
                                }}
                                window.close();
                            </script>";


            ScriptManager.RegisterStartupScript(this, this.GetType(), "ClosePopup", script, false);
            

        }
    }
}