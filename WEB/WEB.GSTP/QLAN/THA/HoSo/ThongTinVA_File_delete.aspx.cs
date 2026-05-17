using BL.GSTP;
using BL.GSTP.AHS;
using BL.GSTP.THA;
using BL.GSTP.Danhmuc;
using DAL.GSTP;
using Module.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Web;
using System.Web.UI.WebControls;


namespace WEB.GSTP.QLAN.THA.HoSo
{
    public partial class ThongTinVA_File_delete : System.Web.UI.Page
    {
        GSTPContext dt = new GSTPContext();
        CultureInfo cul = new CultureInfo("vi-VN");
        public decimal QuocTichVN = 0;
        Decimal CurrUserID = 0;
        String VuViecTemp = "VuViecIDTemp";

        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                CurrUserID = (String.IsNullOrEmpty(Session[ENUM_SESSION.SESSION_USERID] + "")) ? 0 : Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID] + "");
                if (CurrUserID > 0)
                {
                    QuocTichVN = new DM_DATAITEM_BL().GetQuocTichID_VN();
                    if (!IsPostBack)
                    {
                        lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                        lbSoBanAn.Text = "Số bản án sơ thẩm";
                        //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                        lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
                        LoadCombobox();
                        pnGDXX.Visible = false;
                        decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                        THA_BIAN oBiAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
                        string current_id = "";
                        if (oBiAn != null)
                        {
                            current_id = oBiAn.VUANID.ToString();
                        }else
                        {
                            current_id = Request.QueryString["ID"];
                        }

                        if (current_id != null)
                        {

                             

                            string strtype = Request["type"] + "";
                            if (strtype != "list")
                            {
                                //Lay thong tin vuanid theo session
                                cmdQuaylai.Visible = cmdQuaylaiB.Visible = false;
                                cmdUpdateAndNew.Visible = cmdUpdateAndNewB.Visible = false;
                            }
                            else
                            {
                                Session[ENUM_LOAIAN.AN_THA] = "0";
                                //Edit du lieu chon tu ds
                                current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                                if ((Session[ENUM_LOAIAN.AN_THA].ToString() == "0") && (strtype != "") && (current_id == ""))
                                {
                                    LoadHSVuViecCuoiChuaNhapXong();
                                }
                            }

                            Decimal CurrVuAnID = (String.IsNullOrEmpty(current_id + "")) ? 0 : Convert.ToDecimal(current_id);
                            if (CurrVuAnID > 0)
                            {
                                hddID.Value = CurrVuAnID.ToString();
                                LoadThongTinVuAn(Convert.ToDecimal(current_id));
                            }
                            //CheckQuyen();
                        }
                    }
                    SetValue_OtherControl();
                }
                else
                    Response.Redirect("/Login.aspx");
            }
            catch (Exception ex) { lstMsgT.Text = ex.Message; }
        }
        void LoadHSVuViecCuoiChuaNhapXong()
        {
            //Lay thong tin vu viec cuoi cung chua nhap xong (chua co bị can)
            THA_VUAN_BL objVA = new THA_VUAN_BL();
            string curr_user = Session[ENUM_SESSION.SESSION_USERNAME] + "";
            Decimal ToaAnID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID] + "");

            DataTable tbl = objVA.GetLastThaVuAnNotComlete(ToaAnID, curr_user);
            if (tbl != null && tbl.Rows.Count > 0)
            {
                decimal LastID = Convert.ToDecimal(tbl.Rows[0]["ID"] + "");
                hddID.Value = LastID.ToString();
                LoadThongTinVuAn(LastID);
                //txtTenVuAn.Text = "(Đang cập nhật)";
                //lstMsgT.Text = "Vụ án này chưa được cập nhật xong thông tin hồ sơ. Đề nghị bạn tiếp tục cập nhật đầy đủ thông tin! ";
            }
            else
            {
                string current_id = String.IsNullOrEmpty(Request["ID"] + "") ? "" : Request["ID"].ToString();
                if (!String.IsNullOrEmpty(Session[VuViecTemp] + ""))
                {
                    current_id = Session[VuViecTemp].ToString();
                    hddID.Value = Session[VuViecTemp].ToString();

                    LoadThongTinVuAn(Convert.ToDecimal(current_id));
                }
            }
        }
        private void LoadThongTinVuAn(decimal VuAnID)
        {

            THA_VUAN oT = dt.THA_VUAN.Where(x => x.ID == VuAnID).FirstOrDefault();
            if (oT != null)
            {
                //hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //txtMaVuAn.Text = oT.MAVUAN;
                txtTenVuAn.Text = oT.BA_TENVUAN;
                dropLoaiLuaChon.SelectedValue = oT.ISHETHONG.ToString();
                //----------------------------------
                if(oT.BA_NGAYVUAN == DateTime.MinValue || oT.BA_NGAYVUAN + "" ==  "")
                {
                    txtNgayXayra.Text = "";
                }
                else
                {
                    txtNgayXayra.Text = ((DateTime)oT.BA_NGAYVUAN).ToString("dd/MM/yyyy", cul);
                }
                Decimal ToaAnId = 0;
                Decimal ToaAnIdST = 0;
                if (oT.BA_PT_TOAANID != null && oT.BA_PT_TOAANID != 0)
                {
                    ddlGDXX.SelectedValue = "2";
                    pnGDXX.Visible = true;
                    lbNgayBanAn.Text = "Ngày bản án phúc thẩm";
                    lbSoBanAn.Text = "Số bản án phúc thẩm";
                    //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án phúc thẩm";
                    lbToaAn.Text = "Tòa án ra bản án phúc thẩm";
                    txtNgayBanAn.Text = oT.BA_PT_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_PT_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    txtSoBanAn.Text = oT.BA_PT_SO;
                    //txtNgayAnCoHieuLuc.Text = oT.BA_PT_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_PT_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    txtNgayBAST.Text = oT.BA_ST_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                    txtSoBAST.Text = oT.BA_ST_SO;
                    //txtNgayAnCoHieuLucST.Text = oT.BA_ST_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                    ToaAnId = (Decimal)oT.BA_PT_TOAANID;
                    ToaAnIdST = (Decimal)oT.BA_ST_TOAANID;
                    dropTinhChatVuAn.SelectedValue = oT.BA_TINHCHAT.ToString();
                    try
                    {
                        String ToaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>().TEN;
                        txtToaAn.Text = ToaAn;
                        hddToaAnID.Value = ToaAnId.ToString();
                    }
                    catch (Exception ex) { }
                    try
                    {
                        String ToaAnST = dt.DM_TOAAN.Where(x => x.ID == ToaAnIdST).Single<DM_TOAAN>().TEN;
                        txtToaAnST.Text = ToaAnST;
                        hddToaAnIDST.Value = ToaAnIdST.ToString();
                    }
                    catch (Exception ex) { }
                    //------------------------------------
                }
                else
                {
                    ddlGDXX.SelectedValue = "1";
                    pnGDXX.Visible = false;
                    lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                    lbSoBanAn.Text = "Số bản án sơ thẩm";
                    //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                    lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
                    if (oT.BA_ST_TOAANID != null)
                    {
                        txtNgayBanAn.Text = oT.BA_ST_NGAYBANAN + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYBANAN).ToString("dd/MM/yyyy", cul);
                        txtSoBanAn.Text = oT.BA_ST_SO;
                        //txtNgayAnCoHieuLuc.Text = oT.BA_ST_NGAYHIEULUC + "" == "" ? "" : ((DateTime)oT.BA_ST_NGAYHIEULUC).ToString("dd/MM/yyyy", cul);
                        ToaAnId = (Decimal)oT.BA_ST_TOAANID;
                    }
                    dropTinhChatVuAn.SelectedValue = oT.BA_TINHCHAT.ToString();
                    try
                    {
                        String ToaAn = dt.DM_TOAAN.Where(x => x.ID == ToaAnId).Single<DM_TOAAN>().TEN;
                        txtToaAn.Text = ToaAn;
                        hddToaAnID.Value = ToaAnId.ToString();
                    }
                    catch (Exception ex) { }
                }
                Load_ToiDanhBiCanDauvu(VuAnID);

            }
        }

        void LoadDropLoai()
        {

            dropLoaiLuaChon.Enabled = false;
            dropLoaiLuaChon.Items.Clear();
            dropLoaiLuaChon.Items.Add(new ListItem("Thuộc hệ thống quản lý án", "1"));
            dropLoaiLuaChon.Items.Add(new ListItem("Ngoài hệ thống quản lý án", "0"));
            dropLoaiLuaChon.SelectedValue = "0";
            //if (Request["type"] == "list")
            //{
            //    dropLoaiLuaChon.Enabled = false;
            //}
            //else
            //{
            //    dropLoaiLuaChon.Enabled = true;
            //}
        }


        void Load_ToiDanhBiCanDauvu(Decimal VuAnID)
        {
            Decimal BiCanDauVuID = 0;
            List<THA_BIAN> lst = dt.THA_BIAN.Where(x => x.VUANID == VuAnID && x.BICANDAUVU == 1).ToList<THA_BIAN>();
            if (lst != null && lst.Count > 0)
            {
                BiCanDauVuID = Convert.ToDecimal(lst[0].ID + "");
                hddBiCanDauVuID.Value = lst[0].ID.ToString();

                THA_VUAN_BL objBL = new THA_VUAN_BL();
                DataTable tbl = objBL.GetAllToiDanhByBiCan(BiCanDauVuID, VuAnID);
                if (tbl != null && tbl.Rows.Count > 0)
                {
                    rptToiDanh.DataSource = tbl;
                    rptToiDanh.DataBind();
                    pnToiDanhChung.Visible = true;
                }
                else pnToiDanhChung.Visible = false;
            }
            else pnToiDanhChung.Visible = false;
        }
        protected void rptToiDanh_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            decimal ID = Convert.ToDecimal(hddID.Value);
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                DataRowView rv = (DataRowView)e.Item.DataItem;
                MenuPermission oPer = Cls_Comon.GetMenuPer(Request.FilePath, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]));

                LinkButton lkXoa = (LinkButton)e.Item.FindControl("lkXoa");
                Cls_Comon.SetLinkButton(lkXoa, oPer.XOA);

                decimal ma_gd = (String.IsNullOrEmpty(hddMaGiaiDoan.Value)) ? 0 : Convert.ToDecimal(hddMaGiaiDoan.Value);
            }
        }
        String LoadChiTietToiDanh(Decimal luatid, Decimal ToiDanhID, String ArrSapXep, int level)
        {
            string[] temp = null;
            String RootId = "";
            String ToiDanhChinh = "", Temp_ToiDanh = "";
            temp = ArrSapXep.Split('/');

            RootId = temp[0] + "";
            string temp_sx = ArrSapXep.Replace("/", ",");

            //-------------------------
            List<DM_BOLUAT_TOIDANH> lst = dt.DM_BOLUAT_TOIDANH.Where(x => x.LUATID == luatid
                                                                      && x.ARRSAPXEP.Contains(RootId + "/")
                                                                    ).OrderByDescending(y => y.LOAI).ToList();
            if (level > 1)
            {
                Decimal curr_id = 0;
                int loai = 0;
                foreach (string item in temp)
                {
                    if (item.Length > 0)
                    {
                        curr_id = Convert.ToDecimal(item);
                        foreach (DM_BOLUAT_TOIDANH itemTD in lst)
                        {
                            loai = (int)itemTD.LOAI;
                            if (curr_id == itemTD.ID)
                            {
                                if (Convert.ToDecimal(item) == ToiDanhID)
                                {
                                    switch (loai)
                                    {
                                        case 2:
                                            ToiDanhChinh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            ToiDanhChinh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            ToiDanhChinh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                else
                                {
                                    if (Temp_ToiDanh.Length > 0)
                                        Temp_ToiDanh += "<br/>";
                                    switch (loai)
                                    {
                                        case 2:
                                            Temp_ToiDanh += "<b>Điều: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 3:
                                            Temp_ToiDanh += "<b>Khoản: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                        case 4:
                                            Temp_ToiDanh += "<b>Điểm: </b>" + itemTD.TENTOIDANH + "";
                                            break;
                                    }
                                }
                                //-------------------------
                                break;
                            }
                        }
                    }
                }
            }
            string strtoidanh = (Temp_ToiDanh.Length > 0) ? "<br/><i>(" + Temp_ToiDanh + ")</i>" : "";
            return (ToiDanhChinh + strtoidanh);
        }
        private void ResetControls()
        {
            //txtMaVuAn.Text = "";
            //txtNgayBanCaoTrang.Text = txtNgayGiao.Text = txtNgayXayra.Text = "";
            //txtSoBanCaoTrang.Text = txtSoBiCan.Text = txtSoBiCanTamGiam.Text = "";
            //txtSoButLuc.Text = txtTenVuAn.Text = txtTenVuAnKhac.Text = "";

            dropLoaiLuaChon.SelectedIndex = 0;
            //CheckBoxUyQuyen.Checked = false;
            txtTenVuAn.Text = "";
            txtNgayXayra.Text = "";
            txtNgayBanAn.Text = "";
            //txtNgayAnCoHieuLuc.Text = "";
            txtSoBanAn.Text = "";
            dropTinhChatVuAn.SelectedIndex = 0;
            ddlGDXX.SelectedIndex = 0;
            txtToaAn.Text = "";
            hddID.Value = "0";
            txtNgayBAST.Text = "";
            txtSoBAST.Text = "";
            //txtNgayAnCoHieuLucST.Text = "";
            txtToaAnST.Text = "";

            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            Load_ToiDanhBiCanDauvu(VuAnID);
            uDSBiCan.VuAnID = 0;
            uDSBiCan.LoadGrid();

        }
        private void LoadCombobox()
        {
            //dropGio.Items.Clear();
            //for (int i = 0; i < 24; i++)
            //{
            //    if (i < 10)
            //        dropGio.Items.Add(new ListItem("0" + i.ToString(), "0" + i.ToString()));
            //    else
            //        dropGio.Items.Add(new ListItem(i.ToString(), i.ToString()));
            //}
            ////--------------------------

            ////--------------------------------------------------           
            //LoadDropByGroupName(dropLoaiToiPham, ENUM_DANHMUC.LOAITOIPHAM, false);
            //LoadDropByGroupName(dropQuyetDinhTruyTo, ENUM_DANHMUC.QUYETDINHCAOTRANG, false);
            LoadDropLoai();

        }

        void LoadDropByGroupName(DropDownList drop, string GroupName, Boolean ShowChangeAll)
        {
            drop.Items.Clear();
            DM_DATAITEM_BL oBL = new DM_DATAITEM_BL();
            DataTable tbl = oBL.DM_DATAITEM_GETBYGROUPNAME(GroupName);
            if (ShowChangeAll)
                drop.Items.Add(new ListItem("------- chọn --------", "0"));
            foreach (DataRow row in tbl.Rows)
            {
                drop.Items.Add(new ListItem(row["TEN"] + "", row["ID"] + ""));
            }
        }
        protected void cmdUpdateSelect_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                //Lưu vào người dùng
                decimal IDUser = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_USERID]);
                QT_NGUOISUDUNG oNSD = dt.QT_NGUOISUDUNG.Where(x => x.ID == IDUser).FirstOrDefault();
                if ((Session[ENUM_SESSION.SESSION_DONVIID] + "") == oNSD.DONVIID.ToString())
                {
                    oNSD.IDTHA = IDVuViec;
                    dt.SaveChanges();
                }
                Session[ENUM_LOAIAN.AN_THA] = IDVuViec;
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công!";
                Response.Redirect(Cls_Comon.GetRootURL() + "/Trangchu.aspx");
                //Cls_Comon.ShowMessageAndRedirect(this, this.GetType(), "MsgDSDON", "Lưu thông tin thành công, tiếp theo hãy chọn chức năng khác cần thao tác trong danh sách bên trái !", Cls_Comon.GetRootURL() + "/Trangchu.aspx");
            }
        }
        protected void cmdUpdateVuAn_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                decimal IDVuViec = Convert.ToDecimal(hddID.Value);
                if (IDVuViec > 0)
                {
                    //string para = (string.IsNullOrEmpty(Request["type"] + "")) ? "" : "&type=" + (Request["type"].ToString());
                    //Response.Redirect("ThongTinVA.aspx?ID=" + IDVuViec + para);
                    lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công!";
                    
                    //Hien ds Bi can + nut them bị can
                }
            }
            
        }
        protected void cmdUpdateAndNew_Click(object sender, EventArgs e)
        {
            if (SaveData())
            {
                Session[VuViecTemp] = "";
                ResetControls();
                lstMsgT.Text = lstMsgB.Text = "Lưu thông tin vụ án thành công! Bạn hãy nhập thông tin vụ án tiếp theo !";
            }
        }

        private bool SaveData()
        {
            try
            {
                if (!CheckValid())
                    return false;

                if (!SaveDataVuAn())
                {
                    return false;
                }
                
                return true;
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
                return false;
            }
        }
        private bool CheckValid()
        {
            //KT: yeu cau nhap bi can dau vu
            decimal VuAnID = ((string.IsNullOrEmpty(hddID.Value)) || (hddID.Value == "0")) ? 0 : Convert.ToDecimal(hddID.Value);

            try
            {
                THA_BIAN obj = dt.THA_BIAN.Where(x => x.VUANID == VuAnID).Single<THA_BIAN>();
                if (obj == null)
                {
                    Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can cho vụ án!");
                    Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                    return false;
                }
            }
            catch (Exception ex)
            {
                Cls_Comon.ShowMessage(this, this.GetType(), "Thông báo", "Bạn cần nhập bị can cho vụ án!");
                Cls_Comon.SetFocus(this, this.GetType(), lkThemBiCao.ClientID);
                return false;
            }
            return true;
        }

        private bool SaveDataVuAn()
        {
            decimal current_idBiAn = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
            THA_BIAN oBiAn = dt.THA_BIAN.Where(x => x.ID == current_idBiAn).FirstOrDefault();
            decimal current_id = 0;
            string IDvuan = hddID.Value;
            if (oBiAn != null)
            {
                current_id = Convert.ToDecimal(oBiAn.VUANID);
            }
            else if (IDvuan != null)
            {
                current_id = Convert.ToDecimal(IDvuan);
            }
            else
            {
                current_id = Convert.ToDecimal(Request.QueryString["ID"]);
            }

            if (ddlGDXX.SelectedValue == "1")
            {
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                //DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => ( x.ID == 0 || x.ID != current_id) && x.BA_ST_SO == SoBA && x.BA_ST_NGAYBANAN == NgayBA && x.BA_ST_TOAANID == ToaAnRaBA).FirstOrDefault();
                if (oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                    lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở "+ oTA.TEN +" . Vui lòng kiểm tra lại !";
                    return false;
                }
                else
                {
                    lstMsgT.Text = lstMsgB.Text = "";
                    SaveDataVuAn_CheckBanAn();
                }
            }
            else if (ddlGDXX.SelectedValue == "2")
            {
                string SoBAST = txtSoBAST.Text.ToString();
                DateTime NgayBAST = (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBAST = Convert.ToDecimal(hddToaAnIDST.Value);
                string SoBA = txtSoBanAn.Text.ToString();
                DateTime NgayBA = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                Decimal ToaAnRaBA = Convert.ToDecimal(hddToaAnID.Value);
                AHS_PHUCTHAM_BANAN oBAPT = dt.AHS_PHUCTHAM_BANAN.Where(x => x.SOBANAN == SoBA && x.NGAYBANAN == NgayBA && x.TOAANID == ToaAnRaBA).FirstOrDefault();
                AHS_SOTHAM_BANAN oBAST = dt.AHS_SOTHAM_BANAN.Where(x => x.SOBANAN == SoBAST && x.NGAYBANAN == NgayBAST && x.TOAANID == ToaAnRaBAST).FirstOrDefault();
                
                //THA_VUAN oTHA = dt.THA_VUAN.Where(x => (x.ID == 0 || x.ID != current_id) && x.BA_PT_SO == SoBA && x.BA_PT_NGAYBANAN == NgayBA && x.BA_PT_TOAANID == ToaAnRaBA && x.BA_ST_SO == SoBAST && x.BA_ST_NGAYBANAN == NgayBAST && x.BA_ST_TOAANID == ToaAnRaBAST).FirstOrDefault();
                if (oBAPT != null && oBAST != null && (hddID.Value == "0" || hddID.Value == ""))
                {
                    DM_TOAAN oTA = dt.DM_TOAAN.Where(x => x.ID == oBAST.TOAANID).FirstOrDefault();
                    lstMsgT.Text = lstMsgB.Text = "Hồ sơ bản án đã tồn tại ở " + oTA.TEN + " . Vui lòng kiểm tra lại !";
                    return false;
                }
                else
                {
                    lstMsgT.Text = lstMsgB.Text = "";
                    SaveDataVuAn_CheckBanAn();
                }

            }
            return true;
        }

        void SaveDataVuAn_CheckBanAn()
        {
            THA_VUAN oT;
            DateTime date_temp;
            Boolean IsUpdate = false;
            #region "THÔNG TIN vụ án"
            if (hddID.Value == "" || hddID.Value == "0")
                oT = new THA_VUAN();
            else
            {
                decimal ID = Convert.ToDecimal(hddID.Value);
                oT = dt.THA_VUAN.Where(x => x.ID == ID).FirstOrDefault();
                if (oT != null)
                    IsUpdate = true;
            }
            decimal IDtoaraBA = Convert.ToDecimal(hddToaAnID.Value);
            if (ddlGDXX.SelectedValue == "2")
            {
                oT.BA_ST_SO = txtSoBAST.Text;
                oT.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBAST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBAST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLucST.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLucST.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_ST_TOAANID = Convert.ToDecimal(hddToaAnIDST.Value);

                oT.BA_PT_SO = txtSoBanAn.Text;
                oT.BA_PT_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_PT_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_PT_TOAANID = Convert.ToDecimal(hddToaAnID.Value);
            }
            else if (ddlGDXX.SelectedValue == "1")
            {
                oT.BA_ST_SO = txtSoBanAn.Text;
                oT.BA_ST_NGAYBANAN = (String.IsNullOrEmpty(txtNgayBanAn.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayBanAn.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                //oT.BA_ST_NGAYHIEULUC = (String.IsNullOrEmpty(txtNgayAnCoHieuLuc.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayAnCoHieuLuc.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
                oT.BA_ST_TOAANID = Convert.ToDecimal(hddToaAnID.Value);
            }
            //----------------------------------
            oT.BA_TENVUAN = txtTenVuAn.Text.Trim();
            oT.BA_TINHCHAT = Convert.ToDecimal(dropTinhChatVuAn.SelectedValue);

            oT.ISHETHONG = Convert.ToDecimal(dropLoaiLuaChon.SelectedValue);
            oT.IDVUANHETHONG = 0;
            //--------------------------------
            date_temp = (String.IsNullOrEmpty(txtNgayXayra.Text.Trim())) ? DateTime.MinValue : DateTime.Parse(this.txtNgayXayra.Text.Trim(), cul, DateTimeStyles.NoCurrentDateDefault);
            if (date_temp != DateTime.MinValue)
            {
                oT.BA_NGAYVUAN = date_temp;
                oT.BA_THANG = Convert.ToDecimal(date_temp.Month);
                oT.BA_NAM = Convert.ToDecimal(date_temp.Year);
                //oT.GIOXAYRA = Convert.ToDecimal(dropGio.SelectedValue);
            }
            if (!IsUpdate)
            {
                oT.TOAANID = Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]);
                THA_VUAN_BL dsBL = new THA_VUAN_BL();
                oT.TT = dsBL.GETNEWTT((decimal)oT.TOAANID);
                oT.BA_MAVUAN = ENUM_LOAIVUVIEC.AN_THA + Session[ENUM_SESSION.SESSION_MADONVI] + dsBL.GETNEWTT((decimal)oT.TOAANID).ToString();
                //oT.TENVUAN = oT.MAVUAN;
                //oT.MAGIAIDOAN = ENUM_GIAIDOANVUAN.SOTHAM;
                oT.NGAYTAO = DateTime.Now;
                oT.NGUOITAO = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.THA_VUAN.Add(oT);
                dt.SaveChanges();
                //hddID.Value = oT.ID.ToString();
                Session[VuViecTemp] = oT.ID.ToString();
                //hddMaGiaiDoan.Value = oT.MAGIAIDOAN.ToString();
                //anhvh add 26/06/2020
                //GIAI_DOAN_BL GD = new GIAI_DOAN_BL();
                //GD.GAIDOAN_INSERT_UPDATE("1", oT.ID, 2, Convert.ToDecimal(Session[ENUM_SESSION.SESSION_DONVIID]), 0, 0, 0, 0);
            }
            else
            {
                oT.NGAYSUA = DateTime.Now;
                oT.NGUOISUA = Session[ENUM_SESSION.SESSION_USERNAME] + "";
                dt.SaveChanges();
            }
            hddID.Value = oT.ID.ToString();

            #endregion
            //Update_TenVuAn(oT);
        }

        
        protected void cmdQuaylai_Click(object sender, EventArgs e)
        {
            Session[VuViecTemp] = "";
            Response.Redirect("Danhsach.aspx");
        }

        //protected void ddlLoaiQuanhe_SelectedIndexChanged(object sender, EventArgs e)
        //{
        //    LoadCombobox();
        //}

        ////-----------------------------------
        void SetValue_OtherControl()
        {
            Decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal BiCaoID = (String.IsNullOrEmpty(hddBiCaoID.Value)) ? 0 : Convert.ToDecimal(hddBiCaoID.Value);
            uDSBiCan.VuAnID = VuAnID;
            uDSBiCan.RemoveBiCaoID = BiCaoID;
            //-------------------
        }
        protected void ddlGDXX_SelectedIndexChanged(object sender, EventArgs e)
        {
            if (ddlGDXX.SelectedValue == "1")
            {
                pnGDXX.Visible = false;
                lbNgayBanAn.Text = "Ngày bản án sơ thẩm";
                lbSoBanAn.Text = "Số bản án sơ thẩm";
                //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án sơ thẩm";
                lbToaAn.Text = "Tòa án ra bản án sơ thẩm";
            }
            if (ddlGDXX.SelectedValue == "2")
            {
                pnGDXX.Visible = true;
                lbNgayBanAn.Text = "Ngày bản án phúc thẩm";
                lbSoBanAn.Text = "Số bản án phúc thẩm";
                //lbNgaycohieuluc.Text = "Ngày hiệu lực bản án phúc thẩm";
                lbToaAn.Text = "Tòa án ra bản án phúc thẩm";
            }
        }
        protected void lkThemBiCao_Click(object sender, EventArgs e)
        {
            try
            {
                decimal VuAnID = string.IsNullOrEmpty(hddID.Value) ? 0 : Convert.ToDecimal(hddID.Value);
                SaveDataVuAn();

                if (VuAnID > 0)
                {
                    uDSBiCan.VuAnID = VuAnID;
                    Cls_Comon.CallFunctionJS(this, this.GetType(), "popup_them_bc(" + VuAnID + ")");
                }
            }
            catch (Exception ex)
            {
                lstMsgT.Text = lstMsgB.Text = "Lỗi: " + ex.Message;
            }
        }

        protected void rptToiDanh_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string command = e.CommandName;
            decimal toidanh_id = Convert.ToDecimal(e.CommandArgument);
            if (command == "xoa")
            {
                decimal VuAnID = Convert.ToDecimal(Session[ENUM_LOAIAN.AN_THA] + "");
                try
                {
                    xoatoidanh_bicandauvu(toidanh_id);
                }
                catch { }
            }
        }
        void xoatoidanh_bicandauvu(decimal toidanhid)
        {
            decimal bicanid = Convert.ToDecimal(hddBiCanDauVuID.Value);
            decimal VuAnID = (String.IsNullOrEmpty(hddID.Value)) ? 0 : Convert.ToDecimal(hddID.Value);
            Decimal RootID = 0;
            List<THA_SOTHAM_CAOTRANG_DIEULUAT> lst = null;
            DM_BOLUAT_TOIDANH_BL objBL = new DM_BOLUAT_TOIDANH_BL();
            DataTable tbl = objBL.GetAllByParentID(toidanhid);
            RootID = Convert.ToDecimal(tbl.Rows[0]["ArrSapXep"].ToString().Split('/')[1] + "");

            foreach (DataRow row in tbl.Rows)
            {
                toidanhid = Convert.ToDecimal(row["ID"] + "");
                try
                {
                    lst = dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Where(x => x.VUANID == VuAnID
                                                               && x.BICANID == bicanid
                                                               && x.TOIDANHID == toidanhid
                                                             ).ToList<THA_SOTHAM_CAOTRANG_DIEULUAT>();
                    if (lst != null && lst.Count > 0)
                    {
                        foreach (THA_SOTHAM_CAOTRANG_DIEULUAT obj in lst)
                            dt.THA_SOTHAM_CAOTRANG_DIEULUAT.Remove(obj);
                    }
                }
                catch (Exception ex) { }
            }
            dt.SaveChanges();

            Load_ToiDanhBiCanDauvu(VuAnID);
            lstMsgT.Text = lstMsgB.Text = "Xóa thành công!";
        }

        protected void cmdLoadDsBiDonKhac_Click(object sender, EventArgs e)
        {
            uDSBiCan.LoadGrid();
            decimal VuAnID = Convert.ToDecimal(hddID.Value);
            Load_ToiDanhBiCanDauvu(VuAnID);
        }

    }
}