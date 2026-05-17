using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET.BANGIAOAN;
using BL.GSTP.QLAN;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN
{
    public partial class NhanBanGiao : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        private decimal UserID = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                UserID = Session[ENUM_SESSION.SESSION_USERID] + "" == "" ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (!IsPostBack)
                {
                    dgList.CurrentPageIndex = 0;
                    hddPageIndex.Value = "1";
                    LoadDropdownLoadAn();
                    LoadCombobox();
                    LoadDropTrangThaiGiaiQuyet();
                    Cls_Comon.SetButton(cmdNhanBanGiao, false);
                    Cls_Comon.SetButton(cmdHuyNhan, false);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void LoadDropdownLoadAn()
        {
            ddlLoaiAn.Items.Clear();
            ddlLoaiAn.Items.Add(new ListItem("Dân sự", ENUM_LOAIAN.AN_DANSU));
            ddlLoaiAn.Items.Add(new ListItem("Hình sự", ENUM_LOAIAN.AN_HINHSU));
            ddlLoaiAn.Items.Add(new ListItem("HN & GĐ", ENUM_LOAIAN.AN_HONNHAN_GIADINH));
            ddlLoaiAn.Items.Add(new ListItem("KD, TM", ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI));
            ddlLoaiAn.Items.Add(new ListItem("Lao động", ENUM_LOAIAN.AN_LAODONG));
            ddlLoaiAn.Items.Add(new ListItem("Hành chính", ENUM_LOAIAN.AN_HANHCHINH));
            ddlLoaiAn.Items.Add(new ListItem("Phá sản", ENUM_LOAIAN.AN_PHASAN));
            ddlLoaiAn.Items.Add(new ListItem("BP XLHC", ENUM_LOAIAN.BPXLHC));
            ddlLoaiAn.SelectedIndex = 0;
        }
        private void LoadCombobox()
        {
            dropCapxx.Items.Clear();

            if (Session["CAP_XET_XU"] + "" == "CAPHUYEN")
            {
                //dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPTINH")
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }
            else if (Session["CAP_XET_XU"] + "" == "CAPCAO")
            {
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
                //dropCapxx.Items.Add(new ListItem("Giám đốc thẩm", ENUM_GIAIDOANVUAN.THULYGDT.ToString()));
            }
            else
            {
                dropCapxx.Items.Add(new ListItem("-- Tất cả --", ""));
                dropCapxx.Items.Add(new ListItem("Sơ thẩm", ENUM_GIAIDOANVUAN.SOTHAM.ToString()));
                dropCapxx.Items.Add(new ListItem("Phúc thẩm", ENUM_GIAIDOANVUAN.PHUCTHAM.ToString()));
            }

        }


        private void LoadGrid()
        {
            lbthongbao.Text = "";

            decimal toaId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string loaiAnId = ddlLoaiAn.SelectedValue;
            string maVuViec = txtMaVuViec.Text.Trim();
            string tenVuViec = txtTenVuViec.Text.Trim();
            DateTime? thuLyTuNgay = DateTime.Now;
            thuLyTuNgay = (string.IsNullOrEmpty(txtTuNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            DateTime? thuLyDenNgay = DateTime.Now;
            thuLyDenNgay = (string.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            string tinhTrangThuLy = ddlTinhTrangThuLy.SelectedValue;
            string trangThaiGiaiQuyet = ddlTrangThaiGiaiQuyet.SelectedValue;
            string thamPhanGiaiQuyet = txtThamPhanGiaiQuyet.Text.Trim();
            string capXetXu = dropCapxx.SelectedValue;
            string trangThai = rdbTrangthai.SelectedValue;

            VUAN_BANGIAO_MAPPING_BL bl = new VUAN_BANGIAO_MAPPING_BL();

            DataTable oDT = bl.GETS_CHONHAN(
                loaiAnId,
                toaId,
                maVuViec,
                thuLyTuNgay,
                thuLyDenNgay,
                tinhTrangThuLy,
                thamPhanGiaiQuyet,
                tenVuViec,
                trangThaiGiaiQuyet,
                capXetXu,
                trangThai
           );

            #region "Xác định số lượng trang"

            int Total = Convert.ToInt32(oDT.Rows.Count);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            #endregion "Xác định số lượng trang"

            dgList.DataSource = oDT;
            dgList.DataBind();

            Cls_Comon.SetButton(cmdNhanBanGiao, false);
            Cls_Comon.SetButton(cmdHuyNhan, false);
        }

        // Làm trắng danh sách
        private void ClearGrid()
        {
            #region "Xác định số lượng trang"

            int Total = Convert.ToInt32(0);
            hddTotalPage.Value = Cls_Comon.GetTotalPage(Total, dgList.PageSize).ToString();
            lstSobanghiT.Text = lstSobanghiB.Text = "Có <b>" + Total.ToString() + " </b> bản ghi trong <b>" + hddTotalPage.Value + "</b> trang";
            Cls_Comon.SetPageButton(hddTotalPage, hddPageIndex, lbTFirst, lbBFirst, lbTLast, lbBLast, lbTNext, lbBNext, lbTBack, lbBBack, lbTStep1, lbBStep1, lbTStep2,
                         lbBStep2, lbTStep3, lbBStep3, lbTStep4, lbBStep4, lbTStep5, lbBStep5, lbTStep6, lbBStep6);

            #endregion "Xác định số lượng trang"

            dgList.DataSource = null;
            dgList.DataBind();

            Cls_Comon.SetButton(cmdNhanBanGiao, false);
            Cls_Comon.SetButton(cmdHuyNhan, false);
        }

        protected void cmdTimkiem_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void cmdNhanan_Click(object sender, EventArgs e)
        {
            try
            {
                List<BANGIAOAN_INPUT> data = new List<BANGIAOAN_INPUT>();

                lbthongbao.Text = "";
                // Lấy danh sách các trường đã tick chọn
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        BANGIAOAN_INPUT input = new BANGIAOAN_INPUT();
                        input.Id = Item.Cells[0].Text;
                        input.VuViecId = Item.Cells[1].Text;
                        input.VuViecMa = Item.Cells[7].Text;
                        input.VuViecTen = Item.Cells[8].Text;
                        input.LyDoMa = Item.Cells[4].Text;
                        input.LyDoTen = Item.Cells[10].Text;
                        input.NgayGiao = Item.Cells[11].Text;
                        input.ToaAnGiaoTen = Item.Cells[9].Text;
                        input.ToaAnNhanId = Item.Cells[2].Text;
                        input.ToaAnGiaoId = Item.Cells[3].Text;

                        data.Add(input);
                    }
                }

                dgItems.DataSource = data;
                dgItems.DataBind();

                pnDanhsach.Visible = false;
                areaConfirm.Visible = true;
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Bàn giao thất bại. " + ex.Message;
            }
        }
        protected void chkChon_CheckedChanged(object sender, EventArgs e)
        {
            Cls_Comon.SetButton(cmdNhanBanGiao, false);
            Cls_Comon.SetButton(cmdHuyNhan, false);
            //bool anyChecked = false;
            //foreach (DataGridItem Item in dgList.Items)
            //{

            //    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
            //    if (chkChon.Checked)
            //    {
            //        anyChecked = true;
            //        break;
            //    }



            //}

            //Cls_Comon.SetButton(cmdNhanBanGiao, anyChecked);
            //Cls_Comon.SetButton(cmdHuyNhan, anyChecked);
            var listchkChon = new List<bool>();
            foreach (DataGridItem Item in dgList.Items)
            {
                CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                if (chkChon.Checked)
                {
                    listchkChon.Add(chkChon.Checked);
                }
            }
            if (listchkChon.Count > 0)
            {
                if (rdbTrangthai.SelectedValue != "TTBG_DANHAN")
                {
                    Cls_Comon.SetButton(cmdNhanBanGiao, true);
                }
                else
                {
                    Cls_Comon.SetButton(cmdHuyNhan, true);
                }
            }
            else
            {
                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);
            }
        }
        protected void cmdLuu_Click(object sender, EventArgs e)
        {
            try
            {
                foreach (DataGridItem Item in dgItems.Items)
                {
                    string loaiAnId = ddlLoaiAn.SelectedValue;
                    var id = Convert.ToDecimal(Item.Cells[0].Text);
                    var toaAnNhanId = Convert.ToDecimal(Item.Cells[1].Text);
                    var vuViecId = Convert.ToDecimal(Item.Cells[2].Text);

                    // Nhận bàn giao
                    VUAN_BANGIAO_MAPPING_BL bl = new VUAN_BANGIAO_MAPPING_BL();

                    bl.NHAN(loaiAnId, id, vuViecId, toaAnNhanId, DateTime.Now);
                }

                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                lbthongbao.Text = "Nhận án thành công !";
                pnDanhsach.Visible = true;
                areaConfirm.Visible = false;

                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);
            }
            catch (Exception ex)
            {
                lbthongbaoNA.Text = "Nhận án thất bại! " + ex.Message;

                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);
            }

        }
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            pnDanhsach.Visible = true;
            areaConfirm.Visible = false;
        }

        /// <summary>
        /// DataBound event của DataGrid - Xử lý null values an toàn
        /// </summary>
        protected void dgItems_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            try
            {
                if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
                {
                    // Xử lý dữ liệu của từng row để đảm bảo không có lỗi null
                    DataRowView rowView = (DataRowView)e.Item.DataItem;
                }
            }
            catch (Exception ex)
            {
                // Không throw exception để tránh crash trang
            }
        }

        protected void rdbTrangthai_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ClearGrid();

                LoadDropTrangThaiGiaiQuyet();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void dropCapxx_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ClearGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void LoadDropTrangThaiGiaiQuyet()
        {
            ddlTrangThaiGiaiQuyet.Items.Clear();

            ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("-- Tất cả --", ""));
            ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("Chưa giải quyết xong", "1"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Chưa phân công Thẩm phán", "2"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã phân công Thẩm phán", "3"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã lên lịch xét xử", "4"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đang hoãn", "5"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đang tạm đình chỉ", "6"));
            ddlTrangThaiGiaiQuyet.Items.Add(new ListItem("Đã giải quyết xong", "7"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đã xét xử", "8"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Đình chỉ", "9"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Công nhận thỏa thuận của đương sự", "10"));
            //ddlTrangThaiGiaiQuyet.Items.Add(new ListItem(".....Chuyển vụ án", "11"));
        }

        protected void ddlTrangThaiGiaiQuyet_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ClearGrid();

                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        protected void cmdHuyNhan_Click(object sender, EventArgs e)
        {
            try
            {
                List<BANGIAOAN_INPUT> data = new List<BANGIAOAN_INPUT>();

                lbthongbao.Text = "";
                // Lấy danh sách các trường đã tick chọn
                foreach (DataGridItem Item in dgList.Items)
                {
                    CheckBox chkChon = (CheckBox)Item.FindControl("chkChon");
                    if (chkChon.Checked)
                    {
                        BANGIAOAN_INPUT input = new BANGIAOAN_INPUT();
                        input.Id = Item.Cells[0].Text;
                        input.VuViecId = Item.Cells[1].Text;
                        input.VuViecMa = Item.Cells[7].Text;
                        input.VuViecTen = Item.Cells[8].Text;
                        input.LyDoMa = Item.Cells[4].Text;
                        input.LyDoTen = Item.Cells[10].Text;
                        input.NgayGiao = Item.Cells[11].Text;
                        input.ToaAnGiaoTen = Item.Cells[9].Text;
                        input.ToaAnNhanId = Item.Cells[2].Text;
                        input.ToaAnGiaoId = Item.Cells[3].Text;
                        input.NgayNhan = Item.Cells[12].Text;

                        data.Add(input);
                    }
                }
                HuyNhan(data);
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal MappingID = Convert.ToDecimal(e.CommandArgument.ToString());

                //List<decimal> lstDonID = new List<decimal>();
                //lstDonID.Add(ChuyenNhanID);
                switch (e.CommandName)
                {
                    case "HuyNhan":
                        TuChoi(MappingID);
                        LoadGrid();
                        break;
                    case "TraLai":
                        decimal vuViecId = Convert.ToDecimal(e.Item.Cells[1].Text.Trim());
                        decimal toaAnNhanId = Convert.ToDecimal(e.Item.Cells[2].Text.Trim());
                        decimal toaAnGiaoId = Convert.ToDecimal(e.Item.Cells[3].Text.Trim());
                        DateTime ngayNhan = DateTime.Parse(e.Item.Cells[12].Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);

                        TraLai(MappingID, vuViecId, toaAnGiaoId, toaAnNhanId, ngayNhan);
                        break;
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtTraLai = (LinkButton)e.Item.FindControl("lbtTraLai");
                if (rdbTrangthai.SelectedValue == ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_DANHAN)
                {
                    chkChon.Visible = true;
                    lbtHuyChuyen.Visible = false;
                    lbtTraLai.Visible = true;
                }
                else
                {
                    chkChon.Visible = true;
                    lbtHuyChuyen.Visible = true;
                    lbtTraLai.Visible = false;
                }
            }
        }

        protected void ddlLoaiAn_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                ClearGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }

        private void TuChoi(decimal MAPPINGID)
        {
            VUAN_BANGIAO_MAPPING_BL bl = new VUAN_BANGIAO_MAPPING_BL();

            bl.CHANGE_STATUS(Convert.ToDecimal(MAPPINGID), "TTBG_TUCHOI");

            lbthongbao.Text = "Từ chối thành công";
        }

        private bool TraLai(decimal MAPPINGID, decimal vuViecId, decimal toaAnGiaoId, decimal toaAnNhanId, DateTime ngayNhan)
        {
            try
            {
                string loaiAnId = ddlLoaiAn.SelectedValue;

                lbthongbao.Text = "";

                #region Check
                /*switch (loaiAnId)
                {
                    case ENUM_LOAIAN.AN_DANSU:
                        var ads = dt.ADS_DON.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (ads == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.ADS_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_DON_BANGIAO_TAILIEU.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_GIAIDOAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_TAILIEU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_THAMPHAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_DON_XULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_FILE.Any(x => x.DONID == vuViecId  && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_KCKNQDK_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_KCKNQDK_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_KCKNQDK_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_BANAN_FILE.Any(x => dt.ADS_PHUCTHAM_BANAN.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.BANANID) &&  
                                                                x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            //dt.ADS_PHUCTHAM_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_BANAN_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_BANAN_DIEULUAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_SOTHAM_BANAN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_SOTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            dt.ADS_SOTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_KHANGCAO.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_KHANGNGHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_RUTKCKN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ADS_SOTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_SOTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_TONGDAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_TONGDAT_DOITUONG.Any(x => dt.ADS_TONGDAT.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.TONGDATID) && 
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ADS_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 2) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 2) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId &&x.NGAYTAO >= ngayNhan
                            )
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        //// Hồ sơ phúc thẩm
                        //HOSO_PT_BL obj_M = new HOSO_PT_BL();
                        //DataTable tbl = obj_M.Hoso_PT_List_V2(2, vuViecId, 1, 9999);
                        //var result = tbl.AsEnumerable().Where(row => row.Field<DateTime?>("NGAYTAO") >= ngayNhan)
                        //                               .ToList();
                        //if (tbl.AsEnumerable().Where(row => row.Field<decimal>("toa") > 25).Count() > 0)
                        //{
                        //    lbthongbao.Text = "Thông tin hồ sơ phúc thẩm đã có thay đổi, không thể trả án.";
                        //    return false;
                        //}

                        //if (dt.ADS_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan))
                        //{
                        //    lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                        //    return false;
                        //}

                        break;

                    case ENUM_LOAIAN.AN_HINHSU:
                        var ahs = dt.AHS_VUAN.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (ahs == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.AHS_BICANBICAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_BICAN_NHANTHAN.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_BIENPHAPNGANCHAN.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_FILE.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_BICANBICAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_QUYETDINH_BICAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_QUYETDINH_VUAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_THULY.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_KCKNQDK_PHUCTHAM_XULY_KCKNST.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_NGUOITHAMGIATOTUNG.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAY_DK >= ngayNhan) ||
                            //dt.AHS_NGUOITHAMGIATOTUNG_TUCACH.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_NGUOI_DAIDIEN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_PHUCTHAM_BANAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_PHUCTHAM_BANAN_BICAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_PHUCTHAM_BANAN_DIEU_CT.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_PHUCTHAM_BANAN_FILE.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_PHUCTHAM_BICANBICAO.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_PHUCTHAM_HDXX.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_PHUCTHAM_QUYETDINH_BICAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_PHUCTHAM_QUYETDINH_VUAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_PHUCTHAM_THULY.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_BANAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_BANAN_BICAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_BANAN_DIEU_CHITIET.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_BANAN_DIEU_TONGHOP.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_BIENPHAPNGANCHAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_CAOTRANG_DIEULUAT.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_HDXX.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_KHANGCAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_KHANGCAO_YEUCAU.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_KHANGNGHI.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_KHANGNGHI_YEUCAU.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_QUYETDINH_BICAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_QUYETDINH_VUAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_RUTKHANGCAO.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_SOTHAM_RUTKHANGNGHI.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_SOTHAM_THULY.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_THAMPHANGIAIQUYET.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_TONGDAT.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_TONGDAT_DOITUONG.Any(x => dt.AHS_TONGDAT.Where(y => y.VUANID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.ID) && 
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHS_TONGHOPHINHPHAT.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_VUAN_GIAIDOAN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHS_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 1) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 1) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan)
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        break;

                    case ENUM_LOAIAN.AN_HONNHAN_GIADINH:
                        var ahn = dt.AHN_DON.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (ahn == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.AHN_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_DON_BANGIAO_TAILIEU.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_GIAIDOAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_TAILIEU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_THAMPHAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_DON_XULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_KCKNQDK_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_KCKNQDK_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_KCKNQDK_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_BANAN_FILE.Any(x => dt.AHN_PHUCTHAM_BANAN.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.BANANID) &&
                                                                x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_PHUCTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            //dt.AHN_PHUCTHAM_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_BANAN_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_BANAN_DIEULUAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_SOTHAM_BANAN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_SOTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            dt.AHN_SOTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_KHANGCAO.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_KHANGNGHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_RUTKCKN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_SOTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_SOTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_TONGDAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHN_TONGDAT_DOITUONG.Any(x => dt.AHN_TONGDAT.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.TONGDATID) &&
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHN_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 3) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 3) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan)
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        break;

                    case ENUM_LOAIAN.AN_KINHDOANH_THUONGMAI:
                        var akt = dt.AKT_DON.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (akt == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.AKT_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_BANGIAO_TAILIEU.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_GIAIDOAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_TAILIEU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_THAMPHAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_DON_XULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_KCKNQDK_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_KCKNQDK_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_KCKNQDK_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_BANAN_FILE.Any(x => dt.AKT_PHUCTHAM_BANAN.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.BANANID) &&
                                                                x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            //dt.AKT_PHUCTHAM_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SOTHAM_BANAN_ANPHI.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SOTHAM_BANAN_DIEULUAT.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SOTHAM_BANAN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SOTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            dt.AKT_SOTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_KHANGCAO.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_KHANGNGHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_RUTKCKN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AKT_SOTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_SOTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_TONGDAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_TONGDAT_DOITUONG.Any(x => dt.AKT_TONGDAT.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.TONGDATID) &&
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AKT_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 4) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 4) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan)
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        break;

                    case ENUM_LOAIAN.AN_HANHCHINH:
                        var ahc = dt.AHC_DON.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (ahc == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.AHC_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_DON_BANGIAO_TAILIEU.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_GIAIDOAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_TAILIEU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_THAMPHAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_DON_XULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_KCKNQDK_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_KCKNQDK_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_KCKNQDK_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_PHUCTHAM_BANAN.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_PHUCTHAM_BANAN_FILE.Any(x => dt.AHC_PHUCTHAM_BANAN.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.BANANID) &&
                            //                                    x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_PHUCTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            //dt.AHC_PHUCTHAM_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_PHUCTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_SOTHAM_BANAN.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_BANAN_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_BANAN_DIEULUAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_SOTHAM_BANAN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_SOTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            dt.AHC_SOTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_KHANGCAO.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_KHANGNGHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_RUTKCKN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_SOTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_SOTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_TONGDAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.AHC_TONGDAT_DOITUONG.Any(x => dt.AHC_TONGDAT.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.TONGDATID) &&
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.AHC_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 6) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 6) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan)
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        break;

                    case ENUM_LOAIAN.AN_LAODONG:
                        var ald = dt.ALD_DON.AsNoTracking().Where(x => x.ID == vuViecId).Select(x => new
                        {
                            x.ID,
                            x.MAGIAIDOAN
                        }).FirstOrDefault();

                        if (ald == null)
                        {
                            lbthongbao.Text = "Không tìm thấy vụ án";
                            return false;
                        }

                        if (
                            dt.ALD_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_CHUYEN_NHAN_AN.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_DON_BANGIAO_TAILIEU.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_GIAIDOAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_TAILIEU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_THAMPHAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_DON_XULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_KCKNQDK_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_KCKNQDK_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_KCKNQDK_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_KCKNQDK_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_PHUCTHAM_BANAN.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_PHUCTHAM_BANAN_FILE.Any(x => dt.ALD_PHUCTHAM_BANAN.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.BANANID) &&
                            //                                    x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_PHUCTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            //dt.ALD_PHUCTHAM_DUONGSU.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_PHUCTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_PHUCTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_PHUCTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_PHUCTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_PHUCTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SAUXETXU.Any(x => x.VUANID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_BANAN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_BANAN_ANPHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_BANAN_DIEULUAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_SOTHAM_BANAN_FILE.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_SOTHAM_BANAN_TGTT.Any(x => x.DONID == vuViecId && x.NGAYNHANBANAN >= ngayNhan) ||
                            dt.ALD_SOTHAM_HDXX.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_HOAGIAI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_KHANGCAO.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_KHANGNGHI.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_QUYETDINH.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_RUTKCKN.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            //dt.ALD_SOTHAM_THAMGIATOTUNG.Any(x => x.DONID == vuViecId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_SOTHAM_THULY.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_TONGDAT.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_TONGDAT_DOITUONG.Any(x => dt.ALD_TONGDAT.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.TONGDATID) &&
                                                             x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_TRUNGCAU_GIAMDINH.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            dt.ALD_XULY_VIPHAMHC.Any(x => x.VUANID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan) ||
                            // đơn khác
                            dt.DON_KHAC.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && (x.NGAYNHANDON >= ngayNhan || x.NGAYKHANGCAO >= ngayNhan) && x.LOAIANID == 5) ||
                            dt.DON_KHAC_YEUCAU.Any(x => dt.DON_KHAC.Where(y => y.DONID == vuViecId).Select(y => y.ID).ToList().Any(id => id == x.DONKHACID) &&
                                                        x.NGAYTAO >= ngayNhan) ||
                            // đơn chi tiết
                            dt.DON_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYNHANDON >= ngayNhan && x.LOAIANID == 5) ||
                            dt.DON_DUONGSU_CHITIET.Any(x => x.DONID == vuViecId && x.TOA_GIAIQUYET_ID == toaAnNhanId && x.NGAYTAO >= ngayNhan)
                        )
                        {
                            lbthongbao.Text = "Thông tin vụ án đã có thay đổi, không thể trả án.";
                            return false;
                        }

                        break;
                }*/
                #endregion

                if (string.IsNullOrEmpty(lbthongbao.Text))
                {
                    VUAN_BANGIAO_MAPPING_BL bl = new VUAN_BANGIAO_MAPPING_BL();

                    // Kiểm tra thay đổi
                    var ktThayDoiResult = bl.KTTHAYDOI(loaiAnId, MAPPINGID);
                    if (string.IsNullOrEmpty(ktThayDoiResult))
                    {
                        // trả lại án
                        bl.TRALAI(loaiAnId, MAPPINGID);

                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        LoadGrid();
                        lbthongbao.Text = "Trả lại án thành công !";

                        return true;
                    }
                    else
                    {
                        lbthongbao.Text = ktThayDoiResult;

                        return false;
                    }
                }
                else
                {
                    lbthongbao.Text = "Trả lại án không thành công !";

                    return false;
                }
            }
            catch (Exception ex)
            {
                lbthongbaoNA.Text = "Trả án thất bại! " + ex.Message;

                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);

                return false;
            }
        }

        private void HuyNhan(List<BANGIAOAN_INPUT> data)
        {
            foreach (var item in data)
            {
                DateTime ngayNhan = DateTime.Parse(item.NgayNhan, cul, DateTimeStyles.NoCurrentDateDefault);

                var result = TraLai(Convert.ToDecimal(item.Id), Convert.ToDecimal(item.VuViecId), Convert.ToDecimal(item.ToaAnGiaoId), Convert.ToDecimal(item.ToaAnNhanId), ngayNhan);

                if (!result) return;
            }

            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Trả lại án thành công.";
        }

        protected void rptCapNhat_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            var hddVuViecIdCurrent = e.Item.FindControl("hddVuViecId") as HiddenField;
            var hddLyDoMa = e.Item.FindControl("hddLyDoMa") as HiddenField;
            var hddToaAnNhanId = e.Item.FindControl("hddToaAnNhanId") as HiddenField;

            #region DropDown Lý do
            DropDownList lyDoSelectList = e.Item.FindControl("dropLyDo") as DropDownList;
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable dtLyDo = oBL.DM_DATAITEM_GETBYGROUPNAME(ENUM_DANHMUC.LYDOBANGIAOAN);

            // Load dữ liệu Lý do
            lyDoSelectList.Items.Clear();
            if (dtLyDo != null && dtLyDo.Rows.Count > 0)
            {
                foreach (DataRow row in dtLyDo.Rows)
                    lyDoSelectList.Items.Add(new ListItem(row["TEN"] + "", row["MA"] + ""));
            }

            // Chọn lý do hiện tại
            if (!string.IsNullOrEmpty(hddLyDoMa.Value))
            {
                lyDoSelectList.SelectedValue = hddLyDoMa.Value;
            }
            #endregion
        }

        #region "Phân trang"
        protected void lbTBack_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value) - 2;
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) - 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTFirst_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTLast_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddTotalPage.Value) - 1;
                hddPageIndex.Value = Convert.ToInt32(hddTotalPage.Value).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTNext_Click(object sender, EventArgs e)
        {
            try
            {
                dgList.CurrentPageIndex = Convert.ToInt32(hddPageIndex.Value);
                hddPageIndex.Value = (Convert.ToInt32(hddPageIndex.Value) + 1).ToString();
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void lbTStep_Click(object sender, EventArgs e)
        {
            try
            {
                LinkButton lbCurrent = (LinkButton)sender;
                dgList.CurrentPageIndex = Convert.ToInt32(lbCurrent.Text) - 1;
                hddPageIndex.Value = lbCurrent.Text;
                LoadGrid();
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        #endregion
    }
}