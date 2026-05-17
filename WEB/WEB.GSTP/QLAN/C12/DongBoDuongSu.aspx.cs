using BL.GSTP.DLQGC12;
using DAL.GSTP;
using Module.Common;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.C12
{
    public partial class DongBoDuongSu : System.Web.UI.Page
    {
        private GSTPContext dt = new GSTPContext();

        public string columnDynamic = string.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {

            ScriptManager scriptManager = ScriptManager.GetCurrent(this.Page);

            if (!IsPostBack)
            {
                LoadThongtinbanan();

                // set dropdown default
                string trangThaiDongBo = Request["TRANGTHAIDONGBO"] + "";

                if (!string.IsNullOrEmpty(trangThaiDongBo))
                {
                    ddlTrangthaiDongBo.SelectedValue = trangThaiDongBo;
                }

                Load_Data();
            }
        }

        private void LoadThongtinbanan()
        {
            string KHOBAQDIDString = Request["KHOBAQDID"] + "";

            decimal KHOBAQDID;

            decimal.TryParse(KHOBAQDIDString, out KHOBAQDID);

            KHOBAQD kHOBAQD = dt.KHOBAQDs.Where(s => s.ID == KHOBAQDID && s.STATUS == 1).FirstOrDefault();

            if (kHOBAQD == null)
            {
                string soBA = Request["soBA"] + "";
                string ngayBA = Request["ngayBA"] + "";
                string ngayHL = Request["ngayHL"] + "";

                lblSoBAQD.Text = soBA;
                lblNgayBAQD.Text = ngayBA;
                lblNgayHieuLuc.Text = ngayHL;
                return;
            }

            lblSoBAQD.Text = kHOBAQD.SOBAQD;
            lblNgayBAQD.Text = kHOBAQD.NGAYBAQD?.ToString("dd/MM/yyyy");
            lblNgayHieuLuc.Text = kHOBAQD.NGAYHIEULUCBAQD?.ToString("dd/MM/yyyy");
        }

        private void dataGridAllVisible(bool isVisible)
        {
            DgList_All.Visible = isVisible;
        }

        void visibleDataGrid(int page_size, DataTable tbl)
        {
            DgList_All.Visible = true;
            DgList_All.DataSource = tbl;
            DgList_All.PageSize = page_size;
            DgList_All.DataBind();
        }

        protected void ddlTrangthaiDongBo_SelectedIndexChanged(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            pn_thuhoi.Visible = false;
            Load_Data();
        }

        void Load_Data()
        {
            try
            {
                DLQGC12_BL oBL = new DLQGC12_BL();
                dataGridAllVisible(false);
                int page_size = Convert.ToInt32(dropPageSize.SelectedValue), pageindex = Convert.ToInt32(hddPageIndex.Value), count_all = 0;

                string KHOBAQDID = Request["KHOBAQDID"] + "";
                string LINHVUC = Request["LINHVUC"] + "";
                string DONID = Request["DONID"] + "";
                string IsDongBo = Request["IsDongBo"] + "";

                string capxx = Request["capxx"] + "";
                string loaibaqd = Request["loaibaqd"] + "";

                DataTable tbl = new DataTable();

                if (LINHVUC == ENUM_LOAIVUVIEC_TEXT.AN_HINHSU)
                {
                    columnDynamic = "Thông tin bị can, bị cáo";
                }
                else
                {
                    columnDynamic = "Thông tin đương sự";
                }

                pn_thuhoi.Visible = false;

                tbl = oBL.GetPagingDuongSuDongBo(KHOBAQDID, DONID, LINHVUC, txtSearch.Text.Trim(), ddlTrangthaiDongBo.SelectedValue, capxx, loaibaqd, pageindex, page_size);

                if (tbl.Rows.Count > 0)
                {
                    #region "Xác định số lượng trang"

                    count_all = Convert.ToInt32(tbl.Rows[0]["CountAll"] + "");
                    hddTotalPage.Value = Cls_Comon.GetTotalPage(count_all, page_size).ToString();
                    lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + count_all.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                                 lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

                    #endregion "Xác định số lượng trang"
                }
                else
                {
                    hddTotalPage.Value = "1";
                    Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                               lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);
                    lstSobanghiT.Text = lstSobanghiB.Text = "Không có kết quả nào phù hợp yêu cầu tìm kiếm !";
                }

                visibleDataGrid(page_size, tbl);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            CheckBox chkChon = (CheckBox)sender;

            if (chkChon != null && chkChon.Checked)
            {
                string input = chkChon.ToolTip;
                string[] array = input.Split(',');
                if (array.Length < 5)
                {
                    return;
                }

                string trangThaiDuongSu = array[2]; //trạng thái bản án

                // nếu bản án đã đồng bộ (tất cả đã đồng bộ)
                if (trangThaiDuongSu == "2")
                {
                    pn_thuhoi.Visible = true;
                }
                else
                {
                    pn_thuhoi.Visible = false;
                }
            }
            else
            {
                pn_thuhoi.Visible = false;
            }

            foreach (DataGridItem row in DgList_All.Items)
            {
                CheckBox cb = (CheckBox)row.FindControl("chkChon");
                if (cb != null && cb != chkChon)
                {
                    cb.Checked = false;
                }
            }
        }

        private List<KHOBAQD_DUONGSU> GetListDuongSu(string LINHVUC, string KHOBAQDIDString, string DuongSuIdString)
        {
            decimal KHOBAQDID;
            decimal DuongSuId;

            decimal.TryParse(KHOBAQDIDString, out KHOBAQDID);
            decimal.TryParse(DuongSuIdString, out DuongSuId);

            List<KHOBAQD_DUONGSU> lstDuongSu = new List<KHOBAQD_DUONGSU>();

            List<decimal> listDuongSuDaDongBo = dt.KHOBAQD_DUONGSU.Where(s => s.KHOBAQDID == KHOBAQDID && s.STATUS == 1).Select(s => s.DUONGSUID).ToList();

            switch (LINHVUC)
            {
                case ENUM_LOAIVUVIEC_TEXT.AN_HINHSU:
                    DLQGC12_AHS_BL ahsBl = new DLQGC12_AHS_BL();
                    DLQGC12_BL oBL = new DLQGC12_BL();

                    KHOBAQD kHOBAQD = dt.KHOBAQDs.FirstOrDefault(s => s.ID == KHOBAQDID);

                    if (kHOBAQD == null)
                    {
                        return lstDuongSu;
                    }

                    string vloaibaqd = kHOBAQD.LOAIBAQD.ToString();    //= 0: bản án, = 1: quyết định
                    string vbaqd_id = kHOBAQD.IDBAQD.ToString();     //id bản án/quyết định
                    string capxx = kHOBAQD.CAPXX.ToString();        //cấp xét xử sơ thẩm/phúc thẩm
                    string vtoaanId = kHOBAQD.TOAANID.ToString();    //tòa án id
                    decimal vuanID = kHOBAQD.DONID ?? 0;

                    DataTable lstBcbc = ahsBl.GET_BICANBICAO_BY_BAQDID(vbaqd_id, vloaibaqd, capxx);
                    if (lstBcbc != null && lstBcbc.Rows.Count > 0)
                    {
                        foreach (DataRow item in lstBcbc.Rows)
                        {
                            KHOBAQD_DUONGSU ds = null;

                            decimal biCaoId = Convert.ToDecimal(item["ID"] ?? 0);

                            if (biCaoId != DuongSuId)
                            {
                                continue
;
                            }

                            decimal quocTichID = Convert.ToDecimal(item["QUOCTICHID"] ?? 0);
                            decimal thuongtruTinhID = Convert.ToDecimal(item["HKTT"] ?? 0);
                            decimal thuongtruHuyenID = Convert.ToDecimal(item["HKTT_HUYEN"] ?? 0);
                            decimal dantocId = Convert.ToDecimal(item["DANTOCID"] ?? 0);

                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == quocTichID) ?? new DM_DATAITEM();
                            var dantoc = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == dantocId) ?? new DM_DATAITEM();
                            var lstDiaChi = dt.DM_HANHCHINH.Where(x => x.ID == thuongtruTinhID || x.ID == thuongtruHuyenID).ToList();

                            var tinh = lstDiaChi.FirstOrDefault(x => x.ID == thuongtruTinhID) ?? new DM_HANHCHINH();
                            var huyenXa = lstDiaChi.FirstOrDefault(x => x.ID == thuongtruHuyenID) ?? new DM_HANHCHINH();

                            if ((item["LOAIDOITUONG"] + "") == "0") //cá nhân
                            {
                                DateTime ngaySinhDate;
                                DateTime.TryParse(item["NGAYSINH"] + "", out ngaySinhDate);

                                if (quocTich.ID == 2) //là người Việt Nam
                                {
                                    if ((item["XACTHUC_DLDCQG"] + "") == "1") //đã xác thực
                                        ds = new KHOBAQD_DUONGSU()
                                        {
                                            TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                            DONID = vuanID,
                                            DUONGSUID = biCaoId,
                                            DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                            HOVATEN = item["HOTEN"] + "",
                                            GIOITINH = Convert.ToDecimal(item["GIOITINH"] ?? 0),
                                            NAMSINH = item["NAMSINH"] + "",
                                            THANGNAM = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("MM/yyyy") : "",
                                            NGAYTHANGNAM = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd/MM/yyyy") : "",
                                            DIACHICHITIET = item["KHTTCHITIET"] + "",
                                            QUOCTICH = quocTich.MA,
                                            QUOCGIA = quocTich.MA,
                                            SODINHDANH = item["SO_CCCD"] + "",
                                            MAXA = ((huyenXa.TEN ?? "").ToLower().Contains("xã") ? huyenXa.MA : ""),
                                            MAHUYEN = ((huyenXa.TEN ?? "").ToLower().Contains("huyện") ? huyenXa.MA : ""),
                                            MATINH = tinh.MA,
                                            DANTOC = dantoc.MA,
                                            TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                            TENTOIDANHC06 = item["tentoidanh"] + "",
                                            TENHINHPHATC06 = item["tenhinhphat"] + "",
                                        };
                                }
                                else // là người ngước ngoài
                                {
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = vuanID,
                                        DUONGSUID = biCaoId,
                                        DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                        HOTENNN = item["HOTEN"] + "",
                                        QUOCTICHNN = quocTich.MA,
                                        NGAYSINHNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd") : "",
                                        NAMSINHNN = item["NAMSINH"] + "",
                                        THANGNAMNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAMNN = ngaySinhDate != DateTime.MinValue ? ngaySinhDate.ToString("dd/MM/yyyy") : "",
                                        GIOITINHNN = item["GIOITINH"] + "",
                                        SODINHDANHNN = item["SO_CCCD"] + "",
                                        DIACHICHITIET = item["KHTTCHITIET"] + "",
                                        DANTOC = dantoc.MA,
                                        TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                        TENTOIDANHC06 = item["tentoidanh"] + "",
                                        TENHINHPHATC06 = item["tenhinhphat"] + "",
                                    };
                                }
                            }
                            else if ((item["LOAIDOITUONG"] + "") == "1" || (item["LOAIDOITUONG"] + "") == "2") //pháp nhân thương mại || pháp nhân phi thương mại
                            {
                                if ((item["XACTHUC_DLDCQG"] + "") == "1") //đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = vuanID,
                                        DUONGSUID = biCaoId,
                                        DOITUONGPHAMTOI = Convert.ToDecimal(item["LOAIDOITUONG"] ?? 0),
                                        MADDTC = "",
                                        MASOTHUE = "",
                                        TENTOCHUCTIENGVIET = item["HOTEN"] + "",
                                        LOAIHINHTC = item["LOAIDOITUONG"] + "",
                                        SODINHDANHDAIDIEN = item["SO_CCCD"] + "",
                                        HOVATENDAIDIEN = null,
                                        DIACHICHITIETRUSO = item["KHTTCHITIET"] + "",
                                        MAXATRUSO = ((huyenXa.TEN ?? "").ToLower().Contains("xã") ? huyenXa.MA : ""),
                                        MAHUYENTRUSO = ((huyenXa.TEN ?? "").ToLower().Contains("huyện") ? huyenXa.MA : ""),
                                        MATINHTRUSO = tinh.MA,
                                        QUOCGIATRUSO = quocTich.MA,
                                        DANTOC = dantoc.MA,
                                        TUCACHTOTUNG = ENUM_DANSU_TUCACHTOTUNG.BICAO,
                                        TENTOIDANHC06 = item["tentoidanh"] + "",
                                        TENHINHPHATC06 = item["tenhinhphat"] + "",
                                    };
                            }

                            #region lấy danh sách tội danh và hình phạt
                            string lstToiDanh = "<DSToiDanh>";
                            string lstHinhPhatChinh = "<DSHinhPhatChinh>";
                            string lstHinhPhatBoSung = "<DSHinhPhatBoSung>";
                            string toiDanhJson = string.Empty;
                            DataTable toiDanh = ahsBl.GET_TOIDANH_BY_BICAO(biCaoId, capxx, vloaibaqd);
                            if (toiDanh.Rows.Count > 0)
                            {
                                List<ToiDanhModel> toiDanhs = new List<ToiDanhModel>();

                                foreach (DataRow rows in toiDanh.Rows)
                                {
                                    ToiDanhModel toidanh = new ToiDanhModel()
                                    {
                                        maToiDanh = rows["ID"].ToString(),
                                        tenToiDanh = rows["TENTOIDANH"].ToString()
                                    };
                                    lstToiDanh += convertToiDanh(toidanh); //convert tội danh thành XML

                                    #region lấy hình phạt theo tội danh của bị cáo
                                    DataTable dsHinhPhatTbl = ahsBl.GET_HINHPHAT_BY_TOIDANH_BICAO(biCaoId, Convert.ToDecimal(toidanh.maToiDanh), capxx, vloaibaqd);
                                    if (dsHinhPhatTbl.Rows.Count > 0)
                                    {
                                        List<HinhPhatModel> dsHinhPhats = new List<HinhPhatModel>();
                                        foreach (DataRow hp in dsHinhPhatTbl.Rows)
                                        {
                                            HinhPhatModel hinhPhatItem = new HinhPhatModel()
                                            {
                                                maHinhPhat = hp["MAHINHPHAT"].ToString(),
                                                tenHinhPhat = hp["TENHINHPHAT"].ToString(),
                                                thamSoHinhPhat = thamSoHinhPhat(hp),
                                                hinhPhatChinh = hp["ISCHANGE"].ToString() == "0" ? 1 : 0 // Nếu ISCHANGE = "0" là hpc; "1" là hpbs
                                            };

                                            dsHinhPhats.Add(hinhPhatItem);

                                            if (hinhPhatItem.hinhPhatChinh == 1) //là hình phạt chính
                                                lstHinhPhatChinh += convertHinhPhatChinh(hinhPhatItem);
                                            else
                                                lstHinhPhatChinh += convertHinhPhatBoSung(hinhPhatItem); //là hình phạt bổ sung
                                        }

                                        toidanh.dSachHinhPhat = dsHinhPhats;

                                    }
                                    toiDanhs.Add(toidanh);
                                    #endregion
                                }

                                toiDanhJson = JsonConvert.SerializeObject(toiDanhs, Formatting.None);
                            }

                            lstToiDanh += "</DSToiDanh>";
                            lstHinhPhatChinh += "</DSHinhPhatChinh>";
                            lstHinhPhatBoSung += "</DSHinhPhatBoSung>";
                            #endregion

                            if (ds != null)
                            {
                                ds.DSTOIDANHC06 = toiDanhJson;
                                ds.DSTOIDANH = lstToiDanh;
                                ds.DSHINHPHATCHINH = lstHinhPhatChinh;
                                ds.DSHINHPHATBOSUNG = lstHinhPhatBoSung;
                                lstDuongSu.Add(ds);
                            }
                        }
                    }

                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_DANSU:
                    var dataDS = dt.ADS_DON_DUONGSU.Where(x => x.ID == DuongSuId && !listDuongSuDaDongBo.Contains(x.ID)).ToList();
                    foreach (var item in dataDS)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = item.DONID ?? 0,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = item.DONID ?? 0,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = item.DONID ?? 0,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_HANHCHINH:
                    var dataHC = dt.AHC_DON_DUONGSU.Where(x => x.ID == DuongSuId && !listDuongSuDaDongBo.Contains(x.ID)).ToList();
                    foreach (var item in dataHC)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = item.DONID ?? 0,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = item.DONID ?? 0,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = item.DONID ?? 0,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_LAODONG:
                    var dataLD = dt.ALD_DON_DUONGSU.Where(x => x.ID == DuongSuId && !listDuongSuDaDongBo.Contains(x.ID)).ToList();
                    foreach (var item in dataLD)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = item.DONID ?? 0,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = item.DONID ?? 0,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = item.DONID ?? 0,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_KINHDOANH_THUONGMAI:
                    var dataKT = dt.AKT_DON_DUONGSU.Where(x => x.ID == DuongSuId && !listDuongSuDaDongBo.Contains(x.ID)).ToList();
                    foreach (var item in dataKT)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = item.DONID ?? 0,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = item.DONID ?? 0,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = item.DONID ?? 0,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
                case ENUM_LOAIVUVIEC_TEXT.AN_HONNHAN_GIADINH:
                    var dataHN = dt.AHN_DON_DUONGSU.Where(x => x.ID == DuongSuId && !listDuongSuDaDongBo.Contains(x.ID)).ToList();

                    // lấy dữ liệu tống đạt
                    string DONIDString = Request["DONID"] + "";

                    decimal DONID;
                    decimal.TryParse(DONIDString, out DONID);

                    List<AHN_TONGDAT> listTongDat = dt.AHN_TONGDAT.Where(s => s.DONID == DONID).ToList();

                    List<decimal> listTongDatId = listTongDat.Select(s => s.ID).ToList();

                    List<AHN_TONGDAT_DOITUONG> listTongDatDoiTuong = dt.AHN_TONGDAT_DOITUONG.Where(s => listTongDatId.Contains(s.TONGDATID ?? 0)).ToList();

                    foreach (var item in dataHN)
                    {
                        KHOBAQD_DUONGSU ds = null;
                        if (item.LOAIDUONGSU == 1) //cá nhân
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            if (quocTich.ID == 2) //là người Việt Nam
                            {
                                if (item.XACTHUC_DLDCQG == 1) //nếu đã xác thực
                                    ds = new KHOBAQD_DUONGSU()
                                    {
                                        TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                        DONID = item.DONID ?? 0,
                                        DUONGSUID = item.ID,
                                        DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                        HOVATEN = item.TENDUONGSU,
                                        GIOITINH = item.GIOITINH,
                                        NAMSINH = item.NAMSINH + "",
                                        THANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                        NGAYTHANGNAM = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                        DIACHICHITIET = item.TAMTRUCHITIET,
                                        QUOCTICH = quocTich.MA,
                                        QUOCGIA = quocTich.MA,
                                        SODINHDANH = item.SO_CCCD,
                                        MAXA = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                        MAHUYEN = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                        MATINH = diaChiTinh.MA,
                                        TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                        NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                                    };
                            }
                            else // là người ngước ngoài
                            {
                                ds = new KHOBAQD_DUONGSU()
                                {
                                    TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                    DONID = item.DONID ?? 0,
                                    DUONGSUID = item.ID,
                                    DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                    HOTENNN = item.TENDUONGSU,
                                    QUOCTICHNN = quocTich.MA,
                                    NGAYSINHNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd") : "",
                                    NAMSINHNN = item.NAMSINH + "",
                                    THANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("MM/yyyy") : "",
                                    NGAYTHANGNAMNN = (item.NGAYSINH.HasValue && item.NGAYSINH != DateTime.MinValue) ? item.NGAYSINH.Value.ToString("dd/MM/yyyy") : "",
                                    GIOITINHNN = item.GIOITINH + "",
                                    SODINHDANHNN = item.SO_CCCD,
                                    DIACHICHITIET = item.TAMTRUCHITIET,
                                    TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                    NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                                };
                            }
                        }
                        else if (item.LOAIDUONGSU == 2 || item.LOAIDUONGSU == 3) //cơ quan || tổ chức
                        {
                            var quocTich = dt.DM_DATAITEM.FirstOrDefault(x => x.ID == item.QUOCTICHID) ?? new DM_DATAITEM();
                            var diaChi = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUID) ?? new DM_HANHCHINH();
                            var diaChiTinh = dt.DM_HANHCHINH.FirstOrDefault(x => x.ID == item.TAMTRUTINHID) ?? new DM_HANHCHINH();

                            ds = new KHOBAQD_DUONGSU()
                            {
                                TAIKHOANTAO = Session[ENUM_SESSION.SESSION_USERNAME] + "",
                                DONID = item.DONID ?? 0,
                                DUONGSUID = item.ID,
                                DOITUONGPHAMTOI = item.LOAIDUONGSU,
                                MADDTC = "",
                                MASOTHUE = "",
                                TENTOCHUCTIENGVIET = item.TENDUONGSU,
                                LOAIHINHTC = item.LOAIDUONGSU + "",
                                SODINHDANHDAIDIEN = item.SO_CCCD,
                                HOVATENDAIDIEN = item.NGUOIDAIDIEN,
                                DIACHICHITIETRUSO = item.DIACHICOQUAN,
                                MAXATRUSO = ((diaChi.TEN ?? "").ToLower().Contains("xã") ? diaChi.MA : ""),
                                MAHUYENTRUSO = ((diaChi.TEN ?? "").ToLower().Contains("huyện") ? diaChi.MA : ""),
                                MATINHTRUSO = diaChiTinh.MA,
                                QUOCGIATRUSO = quocTich.MA,
                                TUCACHTOTUNG = item.TUCACHTOTUNG_MA,
                                NGAYNHANTONGDAT = listTongDatDoiTuong.FirstOrDefault(s => s.MATUCACH == item.TUCACHTOTUNG_MA)?.NGAYNHANTONGDAT
                            };
                        }

                        if (ds != null)
                            lstDuongSu.Add(ds);
                    }
                    break;
            }

            return lstDuongSu;
        }

        private string thamSoHinhPhat(DataRow row)
        {
            string soNam = row["TG_NAM"].ToString();
            string soThang = row["TG_THANG"].ToString();
            string soNgay = row["TG_NGAY"].ToString();
            string soTien = row["SH_VALUE"].ToString();
            return string.Format("Số Năm: {0}, Số Tháng: {1},  Số ngày: {2}, Số tiền phạt: {3}", getSo(soNam), getSo(soThang), getSo(soNgay), getSoTien(soTien));
        }

        private string getSo(string so)
        {
            if (string.IsNullOrEmpty(so)) return "0";
            return so;
        }

        private string getSoTien(string soTien)
        {
            if (string.IsNullOrEmpty(soTien)) return "0";
            return Convert.ToDecimal(soTien).ToString("N0");

        }

        #region Lấy bản án liên quan hôn nhân
        private string convertDSBALQHonNhan(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnHN(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHN(donID);
                banANLienQuan += getPhucThamBanAnHN(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHN(donID);
                banANLienQuan += getPhucThamBanAnHN(donID);
                banANLienQuan += getSoThamQuyetDinhHN(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHN(decimal donID)
        {
            var stba = dt.AHN_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHN(decimal donID)
        {
            var stba = dt.AHN_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định hôn nhân
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhHN(decimal donID)
        {
            var stba = dt.AHN_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan dân sự
        private string convertDSBALQDanSu(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnDS(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnDS(donID);
                banANLienQuan += getPhucThamBanAnDS(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnDS(donID);
                banANLienQuan += getPhucThamBanAnDS(donID);
                banANLienQuan += getSoThamQuyetDinhDS(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnDS(decimal donID)
        {
            var stba = dt.ADS_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnDS(decimal donID)
        {
            var stba = dt.ADS_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định dân sự
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhDS(decimal donID)
        {
            var stba = dt.ADS_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan hành chính
        private string convertDSBALQHanhChinh(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnHC(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHC(donID);
                banANLienQuan += getPhucThamBanAnHC(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnHC(donID);
                banANLienQuan += getPhucThamBanAnHC(donID);
                banANLienQuan += getSoThamQuyetDinhHC(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHC(decimal donID)
        {
            var stba = dt.AHC_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHC(decimal donID)
        {
            var stba = dt.AHC_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định hành chính
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhHC(decimal donID)
        {
            var stba = dt.AHC_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan lao động
        private string convertDSBALQLaoDong(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnLD(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnLD(donID);
                banANLienQuan += getPhucThamBanAnLD(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnLD(donID);
                banANLienQuan += getPhucThamBanAnLD(donID);
                banANLienQuan += getSoThamQuyetDinhLD(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnLD(decimal donID)
        {
            var stba = dt.ALD_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnLD(decimal donID)
        {
            var stba = dt.ALD_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định lao động
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhLD(decimal donID)
        {
            var stba = dt.ALD_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan kinh doanh thương mại
        private string convertDSBALQKinhDoanhThuongMai(decimal donID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
            if (capxx == "3" && vloaibaqd == "0")
                banANLienQuan += getSoThamBanAnKT(donID);

            //nếu là sơ thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó
            if (capxx == "2" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnKT(donID);
                banANLienQuan += getPhucThamBanAnKT(donID);
            }

            //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án, phúc thẩm bản án, sơ thẩm quyết định của nó
            if (capxx == "3" && vloaibaqd == "1")
            {
                banANLienQuan += getSoThamBanAnKT(donID);
                banANLienQuan += getPhucThamBanAnKT(donID);
                banANLienQuan += getSoThamQuyetDinhKT(donID);
            }

            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamBanAnKT(decimal donID)
        {
            var stba = dt.AKT_SOTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnKT(decimal donID)
        {
            var stba = dt.AKT_PHUCTHAM_BANAN.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYTUYENAN.HasValue ? stba.NGAYTUYENAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYHIEULUC.HasValue ? stba.NGAYHIEULUC.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy sơ thẩm quyết định kinh doanh thương mại
        /// </summary>
        /// <param name="donID"></param>
        /// <returns></returns>
        private string getSoThamQuyetDinhKT(decimal donID)
        {
            var stba = dt.AKT_SOTHAM_QUYETDINH.FirstOrDefault(x => x.DONID == donID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOQD}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYQD.HasValue ? stba.NGAYQD.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.HIEULUCTU.HasValue ? stba.HIEULUCTU.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region Lấy bản án liên quan hình sự
        private string convertDSBALQHinhSu(decimal vuanID, string capxx, string vloaibaqd)
        {
            string banANLienQuan = "<DSBAQDLienQuan>";
            if (capxx == "3") //cấp phúc thẩm
            {
                //nếu là phúc thẩm bản án thì lấy sơ thẩm của nó
                if (capxx == "3" && vloaibaqd == "0")
                    banANLienQuan += getSoThamBanAnHS(vuanID);

                //nếu là phúc thẩm quyết định thì lấy sơ thẩm bản án và phúc thẩm bản án của nó (k cần lấy sơ thẩm quyết định)
                if (capxx == "3" && vloaibaqd == "1")
                {
                    banANLienQuan += getSoThamBanAnHS(vuanID);
                    banANLienQuan += getPhucThamBanAnHS(vuanID);
                }
            }
            banANLienQuan += "</DSBAQDLienQuan>";
            return banANLienQuan;
        }

        /// <summary>
        /// Lấy sơ thẩm bản án hình sự
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getSoThamBanAnHS(decimal vuanID)
        {
            var stba = dt.AHS_SOTHAM_BANAN.FirstOrDefault(x => x.VUANID == vuanID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam></Nam>
                                  <ThangNam></ThangNam>
                                  <NgayThangNam></NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }

        /// <summary>
        /// Lấy phúc thẩm bản án hình sự
        /// </summary>
        /// <param name="vuanID"></param>
        /// <returns></returns>
        private string getPhucThamBanAnHS(decimal vuanID)
        {
            var stba = dt.AHS_PHUCTHAM_BANAN.FirstOrDefault(x => x.VUANID == vuanID);
            if (stba != null)
            {
                var toa = dt.DM_TOAAN.FirstOrDefault(x => x.ID == stba.TOAANID) ?? new DM_TOAAN();
                return $@"<BAQDLienQuan>
                              <SoBAQD>{stba.SOBANAN}</SoBAQD>
                              <NgayBAQD>
                                  <Nam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy") : "")}</Nam>
                                  <ThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM") : "")}</ThangNam>
                                  <NgayThangNam>{(stba.NGAYBANAN.HasValue ? stba.NGAYBANAN.Value.ToString("yyyy-MM-dd") : "")}</NgayThangNam>
                              </NgayBAQD>
                              <MaCQ>{toa.MA}</MaCQ>
                              <CoQuanQD>{toa.TEN}</CoQuanQD>
                              <NgayHieuLucBAQD>
                                  <Nam></Nam>
                                  <ThangNam></ThangNam>
                                  <NgayThangNam></NgayThangNam>
                              </NgayHieuLucBAQD>
                          </BAQDLienQuan>";
            }
            return string.Empty;
        }
        #endregion

        #region convert XML tội danh/hình phạt
        private string convertToiDanh(ToiDanhModel model)
        {
            return $@"<ToiDanh>
                        <MaToiDanh>{model.maToiDanh}</MaToiDanh>
                        <TenToiDanh>{model.tenToiDanh}</TenToiDanh>
                    </ToiDanh>";
        }

        private string convertHinhPhatChinh(HinhPhatModel model)
        {
            return $@"<HinhPhatChinh>{model.tenHinhPhat}</HinhPhatChinh>";
        }

        private string convertHinhPhatBoSung(HinhPhatModel model)
        {
            return $@"<HinhPhatBoSung>{model.tenHinhPhat}</HinhPhatBoSung>";
        }
        #endregion

        protected void DgList_All_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rowView = (DataRowView)e.Item.DataItem;

                LinkButton LinkButtonDuongSuDongBo = (LinkButton)e.Item.FindControl("LinkButtonDuongSuDongBo");
                LinkButton LinkButtonXemGuiLai = (LinkButton)e.Item.FindControl("LinkButtonXemGuiLai");
                LinkButton LinkButtonHuyChuyen = (LinkButton)e.Item.FindControl("LinkButtonHuyChuyen");

                CheckBox CheckBox = (CheckBox)e.Item.FindControl("chkChon");

                string IsDongBo = Request["IsDongBo"] + "";

                if (IsDongBo == "2")
                {
                    LinkButtonDuongSuDongBo.Visible = false;
                    LinkButtonXemGuiLai.Visible = false;
                    LinkButtonHuyChuyen.Visible = false;
                    CheckBox.Visible = false;
                    return;
                }

                var trangThaiBanAn = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIBAQD");
                var trangThaiDuongSu = DataBinder.Eval(e.Item.DataItem, "TRANGTHAIDUONGSU");

                var dUONGSUID = DataBinder.Eval(e.Item.DataItem, "DUONGSUID");

                if (string.IsNullOrEmpty(dUONGSUID.ToString()))
                {
                    LinkButtonDuongSuDongBo.Visible = true;
                }
                else
                {
                    LinkButtonDuongSuDongBo.Visible = false;
                }

                // nếu đã thu hồi hết toàn bộ đương sự
                if (trangThaiBanAn.ToString() == "2" && trangThaiDuongSu.ToString() == "5")
                {
                    LinkButtonXemGuiLai.Visible = true;
                }
                else
                {
                    LinkButtonXemGuiLai.Visible = false;
                }

                // nếu đang chờ đồng bộ thì được hủy chuyển
                if (trangThaiBanAn.ToString() == "0" || (trangThaiBanAn.ToString() == "2" && trangThaiDuongSu.ToString() == "0"))
                {
                    LinkButtonHuyChuyen.Visible = true;
                }
                else
                {
                    LinkButtonHuyChuyen.Visible = false;
                }
            }
        }

        protected void btnThuHoi_Click(object sender, EventArgs e)
        {
            DLQGC12_BL oBL = new DLQGC12_BL();
            decimal vCount = 0;

            foreach (DataGridItem Item in DgList_All.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon != null && chkChon.Checked)
                {
                    string username = Session[ENUM_SESSION.SESSION_USERNAME].ToString();

                    string input = chkChon.ToolTip;
                    string[] array = input.Split(',');
                    string DUONGSUID = array[0];
                    string KHOBAQDID = array[1];
                    string TRANGTHAIDUONGSU = array[2];
                    string ID = array[3];
                    string TRANGTHAIBAQD = array[4];

                    // Lấy dữ liệu từ DB
                    //Nếu trạng thái bản án và trạng thái đương sự đã đồng bộ thì mới dc thu hồi
                    if (TRANGTHAIBAQD == "2" && TRANGTHAIDUONGSU == "2")
                    {
                        //Dữ liệu bị thu hồi sẽ cập nhật STATUS = 0
                        if (oBL.ThuHoiDuLieuDuongsu(KHOBAQDID, Session[ENUM_SESSION.SESSION_USERNAME] + "", txtLyDoThuHoi.Text?.Trim(), DUONGSUID))
                        {
                            vCount++;
                        }
                        else
                        {
                            ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi không thành công!');", true);
                        }
                    }
                    else // Nếu chưa đồng bộ thì hủy chuyển
                    {
                        ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được chuyển sang CSDL quốc gia, hãy thực hiện Hủy chuyển.');", true);
                    }

                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Thu hồi thành công!');", true);
                }

            }

            if (vCount > 0)
            {
                txtLyDoThuHoi.Text = "";
                hddPageIndex.Value = "1";
                Load_Data();
            }

        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            string search = txtSearch.Text.Trim();

            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void HuyChuyen(string input)
        {
            decimal vCountSuccess = 0;
            decimal vCountFail = 0;

            string[] array = input.Split(',');
            string DUONGSUID = array[0];
            string KHOBAQDIDString = array[1];
            string TRANGTHAIDUONGSU = array[2];
            string ID = array[3];
            string TRANGTHAIBAQD = array[4];

            //Nếu đã đông bộ sang Jobshared thì khong cho thu hồi
            DLQGC12_BL oBL = new DLQGC12_BL();

            // nếu bản án khác chờ hủy chuyển thì không được hủy
            if (TRANGTHAIBAQD == "0" || (TRANGTHAIBAQD == "2" && TRANGTHAIDUONGSU == "0"))
            {

                //select ID into p_ID
                //    from KHOBAQD
                //    where DONID = p_DONID
                //      and LINHVUC = p_LINHVUC
                //      and CAPXX = p_CAPXX
                //      and TOAANID = p_TOAANID
                //      and STATUS = 0
                //      and ISGUILAI = 0
                //      and TRANGTHAIBAQD = 5

                string khoBAQDID_OLD = KHOBAQDIDString;

                decimal KHOBAQDID = 0;

                decimal.TryParse(KHOBAQDIDString, out KHOBAQDID);

                KHOBAQD kHOBAQD = dt.KHOBAQDs.FirstOrDefault(s => s.ID == KHOBAQDID);

                if (kHOBAQD != null)
                {
                    KHOBAQD kHOBAQD_OLD = dt.KHOBAQDs.FirstOrDefault(s => s.DONID == kHOBAQD.DONID && s.LINHVUC == kHOBAQD.LINHVUC
                    && s.CAPXX == kHOBAQD.CAPXX && s.TOAANID == kHOBAQD.TOAANID && s.STATUS == 0 && s.ISGUILAI == 0 && s.TRANGTHAIBAQD == 5);

                    if (kHOBAQD_OLD != null)
                    {
                        khoBAQDID_OLD = kHOBAQD_OLD.ID.ToString();
                    }
                }

                if (oBL.HuyChuyenDuLieuDuongSu(KHOBAQDIDString, khoBAQDID_OLD, DUONGSUID))
                {
                    //Thong bao thu hoi thanh cong
                    vCountSuccess++;
                }
                else
                {
                    vCountFail++;
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Hủy chuyển không thành công!');", true);
                }
            }
            else
            {
                vCountFail++;
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã đồng bộ sang CSDL quốc gia, không được Hủy chuyển!');", true);
            }
        }

        protected void DongBo(string input)
        {
            DLQGC12_BL oBL = new DLQGC12_BL();
            decimal vCount = 0;

            string[] array = input.Split(',');
            string DUONGSUID = array[0];
            string KHOBAQDID = Request["KHOBAQDID"] + "";
            string TRANGTHAIDUONGSU = array[2];
            string ID = array[3];
            string TRANGTHAIBAQD = array[4];
            string LINHVUC = Request["LINHVUC"] + "";
            List<KHOBAQD_DUONGSU> listDuongSu = GetListDuongSu(LINHVUC, KHOBAQDID, ID);

            if (listDuongSu.Count == 0)
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "Không có bản ghi nào đồng bộ", true);
                return;
            }

            if (!string.IsNullOrEmpty(DUONGSUID))
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu đã được đồng bộ, không được đồng bộ lại');", true);
            }
            else
            {
                if (oBL.Insert_DuLieu_DuongSu_DongBo(listDuongSu, KHOBAQDID, Session[ENUM_SESSION.SESSION_USERNAME] + ""))
                {
                    vCount++;
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đồng bộ không thành công!');", true);
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Đồng bộ thành công!');", true);
            }
        }

        protected void GuiLai(string input)
        {
            DLQGC12_BL oBL = new DLQGC12_BL();
            decimal vCount = 0;

            string[] array = input.Split(',');
            string DUONGSUID = array[0];
            string KHOBAQDID = Request["KHOBAQDID"] + "";
            string TRANGTHAIDUONGSU = array[2];
            string ID = array[3];
            string TRANGTHAIBAQD = array[4];
            string LINHVUC = Request["LINHVUC"] + "";

            if (TRANGTHAIBAQD != "2")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Bản án chưa được đồng bộ sang CSDL quốc gia, vui lòng chờ');", true);
                return;
            }

            if (TRANGTHAIDUONGSU != "5")
            {
                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Dữ liệu chưa được thu hồi sang CSDL quốc gia, không được gửi lại!');", true);
            }
            else
            {

                List<KHOBAQD_DUONGSU> listDuongSu = GetListDuongSu(LINHVUC, KHOBAQDID, ID);

                if (oBL.GuiLaiDuLieuDuongSu(KHOBAQDID, Session[ENUM_SESSION.SESSION_USERNAME] + "", DUONGSUID, listDuongSu))
                {
                    vCount++;
                }
                else
                {
                    ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại không thành công!');", true);
                }

                ScriptManager.RegisterClientScriptBlock(this, this.GetType(), "alertMessage", "alert('Gửi lại thành công!');", true);
            }
        }

        protected void DgList_All_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            string input = e.CommandArgument.ToString();

            switch (e.CommandName)
            {
                case "HuyChuyen":
                    HuyChuyen(input);
                    break;
                case "GuiLai":
                    GuiLai(input);
                    break;
                case "DongBo":
                    DongBo(input);
                    break;
            }

            hddPageIndex.Value = "1";
            Load_Data();
        }


        #region "Phân trang"

        protected void dropPageSize_SelectedIndexChanged(object sender, EventArgs e)
        {
            dropPageSize.SelectedValue = dropPageSize.SelectedValue;
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTBack_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
            Load_Data();
        }

        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = "1";
            Load_Data();
        }

        protected void lbTLast_Click(object sender, EventArgs e)
        {
            //dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
            hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
            Load_Data();
        }

        protected void lbTNext_Click(object sender, EventArgs e)
        {
            hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
            Load_Data();
        }

        protected void lbTStep_Click(object sender, EventArgs e)
        {
            LinkButton lbCurrent = (LinkButton)sender;
            hddPageIndex.Value = lbCurrent.Text;
            Load_Data();
        }
        #endregion "Phân trang"
    }
}