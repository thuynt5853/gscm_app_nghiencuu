using BL.GSTP;
using BL.GSTP.ADS;
using BL.GSTP.BANGSETGET.BANGIAOAN;
using BL.GSTP.THA;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web.Script.Serialization;
using System.Web.UI.WebControls;

namespace WEB.GSTP.QLAN.THA
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
                    LoadDropLoai();
                    LoadDropTinhTrangGQ();
                    LoadGrid();
                    Cls_Comon.SetButton(cmdNhanBanGiao, false);
                    Cls_Comon.SetButton(cmdHuyNhan, false);
                }
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        void LoadDropLoai()
        {
            dropLoaiLuaChon.Items.Clear();
            //dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            dropLoaiLuaChon.Items.Add(new ListItem("Bị án được uỷ thác THA", "2"));
            //dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "2"));
        }
        protected void dropLoaiLuaChon_SelectedIndexChanged(object sender, EventArgs e)
        {
            try
            {
                dropTinhTrangGQ.SelectedIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
            }
            catch (Exception ex)
            {
                lbthongbao.Text = ex.Message;
            }
        }

        void LoadDropTinhTrangGQ()
        {
            dropTinhTrangGQ.Items.Clear();
            dropTinhTrangGQ.Items.Add(new ListItem("--Tất cả--", "0"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Chưa giải quyết", "1"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã thụ lý", "2"));
            dropTinhTrangGQ.Items.Add(new ListItem("+Đã giải quyết", "6"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ thi hành án", "3"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có QĐ ủy thác thi hành án", "4"));
            dropTinhTrangGQ.Items.Add(new ListItem(".....Đã có GQ đơn/CV yêu cầu thi hành án", "5"));

        }

        private void LoadGrid()
        {
            lbthongbao.Text = "";

            decimal toaId = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
            string maVuViec = txtMaVuViec.Text.Trim();
            string tenVuViec = txtTenVuViec.Text.Trim();
            string biAnTen = txtTenBiAn.Text.Trim();
            string biAnMa = txtMaBiAn.Text.Trim();
            string cmnd = txtSoCMND.Text.Trim();
            string soBanAn = txtSoBanAn.Text.Trim();

            DateTime? ngayBanAn = DateTime.Now;
            ngayBanAn = (string.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            string tuNgay = txtTuNgay.Text.Trim();
            string denNgay = txtDenNgay.Text.Trim();
            //tuNgay = (string.IsNullOrEmpty()) ? (DateTime?)null : DateTime.Parse(this.txtTuNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            
            //DateTime? denNgay = DateTime.Now;
            //denNgay = (string.IsNullOrEmpty(txtDenNgay.Text.Trim())) ? (DateTime?)null : DateTime.Parse(this.txtDenNgay.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            int trangThaiGiaiQuyet = Convert.ToInt32(dropTinhTrangGQ.SelectedValue);
            string trangThai = rdbTrangthai.SelectedValue;
            int tinhtrangQd = Convert.ToInt32(ddlTrangThaiGiaiQuyet.SelectedValue);

            int loai = Convert.ToInt32(dropLoaiLuaChon.SelectedValue);
            THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();

            DataTable oDT = null;
            if (loai == 1)
                oDT = bl.GETS_CHONHAN(toaId,biAnMa,biAnTen, maVuViec, tenVuViec,soBanAn,ngayBanAn,trangThaiGiaiQuyet,cmnd,tuNgay,denNgay,trangThai);
            else
                oDT = bl.GETS_CHONHAN_THA(toaId, biAnMa, biAnTen, maVuViec, tenVuViec, soBanAn, ngayBanAn, trangThaiGiaiQuyet, tinhtrangQd, cmnd, tuNgay, denNgay, trangThai);

           

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
                        input.NgayGiao = Item.Cells[14].Text;
                        input.ToaAnGiaoTen = Item.Cells[4].Text;
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
                if (rdbTrangthai.SelectedValue != "1")
                {
                    Cls_Comon.SetButton(cmdNhanBanGiao, true);
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
                    var id = Convert.ToDecimal(Item.Cells[0].Text);
                    var toaAnNhanId = Convert.ToDecimal(Item.Cells[1].Text);
                    var vuViecId = Convert.ToDecimal(Item.Cells[2].Text);

                    // Nhận bàn giao
                    THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();

                    bl.NHAN(id, vuViecId, toaAnNhanId);
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
                LoadDropTinhTrangGQ();
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                Cls_Comon.SetButton(cmdNhanBanGiao, false);
                Cls_Comon.SetButton(cmdHuyNhan, false);
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
                        var id = Convert.ToDecimal(Item.Cells[0].Text);

                        // Nhận bàn giao
                        THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();
                        bl.CHANGE_STATUS(id, ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_TUCHOI);


                    }
                }
                dgList.CurrentPageIndex = 0;
                hddPageIndex.Value = "1";
                LoadGrid();
                // Hiển thị thông báo thành công
                lbthongbao.Text = "Nhận án thành công!";
            }
            catch (Exception ex) { lbthongbao.Text = ex.Message; }
        }
        protected void dgList_ItemCommand(object source, DataGridCommandEventArgs e)
        {
            try
            {
                decimal mappingId = Convert.ToDecimal(e.CommandArgument.ToString());

                switch (e.CommandName)
                {
                    case "HuyNhan":
                        TuChoi(mappingId);
                        LoadGrid();
                        break;
                    case "Nhan":
                        // Get the row data from the grid to extract all needed parameters
                        DataGridItem item = e.Item;

                        // Extract values from the cells in the DataGrid row
                        decimal id = Convert.ToDecimal(item.Cells[0].Text); // MAPPINGID
                        decimal vuViecId = Convert.ToDecimal(item.Cells[1].Text); // VUANID
                        decimal toaAnNhanId = Convert.ToDecimal(item.Cells[2].Text); // TOAANNHANID

                        // Tạo đối tượng business logic để xử lý việc nhận án
                        THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();

                        // Gọi phương thức NHAN với đầy đủ tham số cần thiết
                        bl.NHAN(id, vuViecId, toaAnNhanId);

                        // Cập nhật giao diện người dùng sau khi nhận án thành công
                        dgList.CurrentPageIndex = 0;
                        hddPageIndex.Value = "1";
                        // Refresh the grid after processing
                        LoadGrid();
                        // Hiển thị thông báo thành công
                        lbthongbao.Text = "Nhận án thành công!";

                        // Ẩn/hiện panel phù hợp
                        pnDanhsach.Visible = true;
                        areaConfirm.Visible = false;
                        break;
                }
            }
            catch (Exception ex)
            {
                lbthongbao.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void dgList_ItemDataBound(object sender, DataGridItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                CheckBox chkChon = (CheckBox)e.Item.FindControl("chkChon");
                //LinkButton lbtHuyChuyen = (LinkButton)e.Item.FindControl("lbtHuyChuyen");
                LinkButton lbtNhanChuyen = (LinkButton)e.Item.FindControl("lbtNhanChuyen");
                if (rdbTrangthai.SelectedValue == ENUM_TRANGTHAIBANGIAOAN_MA.TTBG_DANHAN)
                {
                    chkChon.Visible = false;
                    //lbtHuyChuyen.Visible = false;
                    lbtNhanChuyen.Visible = false;
                }
                else
                {
                    chkChon.Visible = true;
                    //lbtHuyChuyen.Visible = true;
                    lbtNhanChuyen.Visible = true;
                }

            }
        }

        private void TuChoi(decimal MAPPINGID)
        {
            string loaiAnId = "1";

            THA_BANGIAO_MAPPING_BL bl = new THA_BANGIAO_MAPPING_BL();

            bl.CHANGE_STATUS(Convert.ToDecimal(MAPPINGID), "TTBG_TUCHOI");
        }

        private void HuyNhan(List<decimal> lstDonID)
        {
            ADS_DON_BL Bl = new ADS_DON_BL();

            for (int i = 0; i < lstDonID.Count; i++)
            {
                var ChuyenNhanID = lstDonID[i];
                decimal DonID_New = 0;
                ADS_CHUYEN_NHAN_AN ObjChuyenAn = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.ID == ChuyenNhanID).FirstOrDefault();
                if (ObjChuyenAn != null)
                {
                    int LoaiVuViec = Convert.ToInt32(ENUM_LOAIVUVIEC.AN_DANSU);
                    if (ObjChuyenAn.MAP_VUANID_NEW.GetValueOrDefault(0) > 0)
                    {
                        DonID_New = ObjChuyenAn.MAP_VUANID_NEW.Value;
                        bool IsThuLy = false;

                        IsThuLy = Bl.Check_ThuLy(DonID_New);
                        if (IsThuLy)
                        {
                            lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                        }

                        if (!IsThuLy)
                        {
                            if (ObjChuyenAn != null)
                            {
                                ObjChuyenAn.MAP_VUANID_NEW = null;
                                ObjChuyenAn.NGUOITAO_PHUCTHAM = null;
                                ObjChuyenAn.NGAYTAO_PHUCTHAM = null;
                                ObjChuyenAn.TRANGTHAI = 0;
                                ObjChuyenAn.NGAYNHAN = null;
                                dt.SaveChanges();
                            }
                            //Luu thong tin ho so vu an khi xoa khi hủy nhận án
                            string strUserName = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                            ADS_DON oDonNew = dt.ADS_DON.Where(x => x.ID == DonID_New).FirstOrDefault();
                            var json = new JavaScriptSerializer().Serialize(oDonNew);
                            ADS_DON_BL oBL = new ADS_DON_BL();
                            if (oBL.HISTORY_ALLDATA_BY_VUANID(DonID_New, 2, Session[ENUM_SESSION.SESSION_USERID] + "", strUserName, "Nhân án Dan su ", "Xóa", json) == false)
                            {
                                break;
                            }
                            //Ket thuc 

                            Bl.DELETE_ALLDATA_BY_VUANID(DonID_New.ToString());
                            GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                            ADS_DON oVuan = dt.ADS_DON.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                            gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), DonID_New, Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            DM_DATAITEM oIT = dt.DM_DATAITEM.Where(x => x.ID == ObjChuyenAn.TRUONGHOPGIAONHANID).FirstOrDefault();

                            if (oDonNew.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                                oVuan.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                            dt.SaveChanges();
                        }
                        else
                        {
                            return;
                        }
                    }
                    else
                    {
                        ADS_DON oVuan = dt.ADS_DON.Where(x => x.ID == ObjChuyenAn.VUANID).FirstOrDefault();
                        if (oVuan.MAGIAIDOAN == ENUM_GIAIDOANVUAN.PHUCTHAM_QDK)
                        {
                            ADS_CHUYEN_NHAN_AN_BL _chuyenNhanAnBl = new ADS_CHUYEN_NHAN_AN_BL();
                            var oldVuAnId = _chuyenNhanAnBl.getDonIdOld(oVuan.ID);
                            //lay chuyen an tu st len pt tdc
                            ADS_CHUYEN_NHAN_AN chuyenAnSTlenPTTDC = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.MAP_VUANID_NEW == oVuan.ID).FirstOrDefault();
                            List<ADS_SOTHAM_THULY> oThuLyST = dt.ADS_SOTHAM_THULY.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_SOTHAM_HDXX> oSTNguoiTienHanhToTung = dt.ADS_SOTHAM_HDXX.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_DON_THAMPHAN> oThamPhanST = dt.ADS_DON_THAMPHAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_SOTHAM_BANAN> oBanAnST = dt.ADS_SOTHAM_BANAN.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_SOTHAM_QUYETDINH> oQDST = dt.ADS_SOTHAM_QUYETDINH.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_SOTHAM_KHANGCAO> oKCST = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();
                            List<ADS_SOTHAM_KHANGNGHI> oKNST = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.NGAYTAO >= chuyenAnSTlenPTTDC.NGAYTAO).ToList();

                            if ((oThuLyST != null && oThuLyST.Count > 0) ||
                                (oSTNguoiTienHanhToTung != null && oSTNguoiTienHanhToTung.Count > 0) ||
                                (oThamPhanST != null && oThamPhanST.Count > 0) ||
                                (oBanAnST != null && oBanAnST.Count > 0) ||
                                (oQDST != null && oQDST.Count > 0) ||
                                (oKCST != null && oKCST.Count > 0) ||
                                (oKNST != null && oKNST.Count > 0))
                            {
                                lbthongbao.Text = "Án đã được thay đổi sau khi nhận. Không được phép hủy nhận án.";
                                return;
                            }
                            else
                            {
                                ADS_DON oVuAnOld = dt.ADS_DON.Where(x => x.ID == oldVuAnId).FirstOrDefault();
                                ADS_CHUYEN_NHAN_AN objChuyenAnLanCuoi = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID).OrderByDescending(x => x.ID).FirstOrDefault();
                                ADS_CHUYEN_NHAN_AN objChuyenAnLanGanCuoi = dt.ADS_CHUYEN_NHAN_AN.Where(x => x.VUANID == oldVuAnId && x.TOACHUYENID == oVuAnOld.TOAANID && x.ID < objChuyenAnLanCuoi.ID).OrderByDescending(x => x.ID).FirstOrDefault();
                                if (objChuyenAnLanGanCuoi == null)
                                {
                                    #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                    List<ADS_SOTHAM_KHANGCAO> khangCaos = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKHANGCAO == 2).ToList();
                                    if (khangCaos != null && khangCaos.Count > 0)
                                    {
                                        foreach (ADS_SOTHAM_KHANGCAO kc in khangCaos)
                                        {
                                            kc.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    List<ADS_SOTHAM_KHANGNGHI> khangNghis = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKN == 2).ToList();
                                    if (khangNghis != null && khangNghis.Count > 0)
                                    {
                                        foreach (ADS_SOTHAM_KHANGNGHI kn in khangNghis)
                                        {
                                            kn.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                }
                                else
                                {
                                    #region toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                    List<ADS_SOTHAM_KHANGCAO> khangCaos = dt.ADS_SOTHAM_KHANGCAO.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKHANGCAO == 2 && x.NGAYTAO >= objChuyenAnLanGanCuoi.NGAYTAO && x.NGAYTAO <= objChuyenAnLanCuoi.NGAYTAO).ToList();
                                    if (khangCaos != null && khangCaos.Count > 0)
                                    {
                                        foreach (ADS_SOTHAM_KHANGCAO kc in khangCaos)
                                        {
                                            kc.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    List<ADS_SOTHAM_KHANGNGHI> khangNghis = dt.ADS_SOTHAM_KHANGNGHI.Where(x => x.DONID == oldVuAnId && x.TINHTRANG_GIAIQUYET == 1 && x.LOAIKN == 2 && x.NGAYTAO >= objChuyenAnLanGanCuoi.NGAYTAO && x.NGAYTAO <= objChuyenAnLanCuoi.NGAYTAO).ToList();
                                    if (khangNghis != null && khangNghis.Count > 0)
                                    {
                                        foreach (ADS_SOTHAM_KHANGNGHI kn in khangNghis)
                                        {
                                            kn.TINHTRANG_GIAIQUYET = 0;
                                            dt.SaveChanges();
                                        }
                                    }
                                    #endregion toancau - anhnt update lại kết quả kháng cáo/kháng nghị
                                }
                                ObjChuyenAn.NGUOITAO_PHUCTHAM = null;
                                ObjChuyenAn.NGAYTAO_PHUCTHAM = null;
                                ObjChuyenAn.TRANGTHAI = 0;
                                ObjChuyenAn.NGAYNHAN = null;

                                if (oVuAnOld != null)
                                    oVuAnOld.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                                dt.SaveChanges();
                            }
                        }
                        else
                        {
                            bool IsThuLy = Bl.Check_ThuLy(ObjChuyenAn.VUANID.Value);
                            if (!IsThuLy)
                            {
                                ObjChuyenAn.NGUOITAO_PHUCTHAM = null;
                                ObjChuyenAn.NGAYTAO_PHUCTHAM = null;
                                ObjChuyenAn.TRANGTHAI = 0;
                                dt.SaveChanges();
                                GIAI_DOAN_BL gdbl = new GIAI_DOAN_BL();
                                gdbl.GIAIDOAN_DELETES(LoaiVuViec.ToString(), Convert.ToDecimal(ObjChuyenAn.VUANID), Convert.ToDecimal(oVuan.MAGIAIDOAN));
                            }
                            else
                            {
                                lbthongbao.Text = "Án đã được thụ lý. Không được phép hủy nhận án.";
                                return;
                            }
                        }

                    }
                }
            }
            dgList.CurrentPageIndex = 0;
            hddPageIndex.Value = "1";
            LoadGrid();
            lbthongbao.Text = "Hủy nhận án thành công.";
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