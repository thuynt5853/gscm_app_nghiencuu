<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true"
    CodeBehind="Dulieudanhmuc.aspx.cs" Inherits="WEB.GSTP.Danhmuc.KetLuanGDTTT.Dulieudanhmuc" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageSize" runat="server" Value="20" />
    <style type="text/css">
        .lbTitle {
            float: left;
            width: 18%;
            margin-bottom: 3px;
            font-weight: bold;
        }

        .inputData {
            float: left;
            width: 80%;
            margin-bottom: 8px;
        }

        .lbTitle_DonCap {
            float: left;
            width: 13%;
            margin-bottom: 3px;
            font-weight: bold;
        }

        .inputData_DonCap {
            float: left;
            width: 86.7%;
            margin-bottom: 8px;
        }



        .clear {
            clear: both;
        }

        #DaCap_Info {
            margin-left: 10px;
            width: 73%;
            float: left;
        }

        .DataInfo {
            margin-left: 5px;
            margin-top: 10px;
            width: 99%;
            float: left;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        .inputSearch {
            padding-left: 5px;
            padding-right: 5px;
            float: left;
            margin-right: 5px;
        }

        .head_DaCap {
            width: 100%;
            margin-bottom: 10px;
            float: left;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        .head_DaCap_Left {
            float: left;
            width: 25%;
        }

        .head_DaCap_Right {
            float: left;
            width: 73%;
            margin-left: 11px;
        }

        .cssTree {
            width: 25%;
            float: left;
            border-right: 1px solid #ccc;
            min-height: 300px;
            overflow: auto;
        }

        .head_panelDaCap {
            float: left;
            width: 100%;
            margin-top: 10px;
            border-top: 1px solid #ccc;
            padding-top: 10px;
        }

        .table_detail {
            width: 100%;
        }

            .table_detail tr, td {
                padding: 5px;
            }

        .table2 .header {
            width: 100%;
            text-align: center;
        }

            .table2 .header td {
                border-left: solid 1px white;
                border-bottom: solid 1px white;
            }
    </style>
    <div class="box">

        <div class="box_nd">
            <div class="truong" style="float: left; width: 98.8%;">
                <div class="class_nhomDM" style="display: none;">
                    <span style="margin-left: 5px; margin-right: 3px;"><b>CHỌN DANH MỤC</b></span>
                    <asp:DropDownList CssClass="chosen-select" ID="dropNhomDanhMuc" runat="server" Width="650px" AutoPostBack="True" OnSelectedIndexChanged="dropNhomDanhMuc_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <asp:Panel ID="pnlDonCap" runat="server">
                    <div class="DataInfo" style="border-top: none;">
                        <div class="button" style="margin-bottom: 10px; display: none;">
                            <asp:LinkButton ID="btnThem_DonCap" runat="server" Visible="false" CssClass="icon_them" Text="Thêm mới" OnClick="btnThem_DonCap_Click"></asp:LinkButton>
                        </div>


                        <div class="clear"></div>
                        <table class="table_detail">
                            <tr>
                                <td style="font-weight: bold; width: 100px;">Tên<asp:Label runat="server" ID="Label1" Text=" (*)" ForeColor="Red"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtTen_DonCap" CssClass="user" runat="server" Width="50%" MaxLength="250"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Mã<asp:Label runat="server" ID="Label3" Text=" (*)" ForeColor="Red"></asp:Label></td>
                                <td>
                                    <asp:TextBox ID="txtMa_DonCap" CssClass="user" Width="50%" runat="server" MaxLength="50"></asp:TextBox></td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Áp dụng cho</td>
                                <td>
                                    <asp:CheckBoxList ID="chkLoaiAn" runat="server" RepeatColumns="4" /></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Ghi chú</td>
                                <td>
                                    <asp:TextBox ID="txtGhiChu_DonCap" CssClass="user" runat="server" Width="50%" MaxLength="250"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td style="font-weight: bold;">Thứ tự</td>
                                <td>
                                    <asp:TextBox ID="txtThuTu_DonCap" CssClass="user" Width="9%" runat="server" MaxLength="3"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;">Trạng thái</td>
                                <td>
                                    <asp:CheckBox ID="chkTrangThai_DonCap" runat="server" /></td>
                            </tr>
                            <tr>
                                <td style="font-weight: bold;"></td>
                                <td>
                                    <asp:Button ID="cmdUpdate_DonCap" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return KtratenDV()" OnClick="btnUpdate_DonCap_Click" />
                                    <asp:Button ID="cmdXoa_DonCap" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnXoa_DonCap_Click" />
                                    <asp:Button ID="cmdLamMoi_DonCap" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLamMoi_DonCap_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Label runat="server" ID="lbthongbao_DonCap" ForeColor="Red" Text=""></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlDaCap" runat="server" Style="margin-top: 20px; width: 100%;">
                    <div class="head_DaCap">
                        <div class="head_DaCap_Left">
                            <h3>Cây dữ liệu danh mục</h3>
                        </div>
                        <div class="head_DaCap_Right">
                            <h3>Thông tin dữ liệu danh mục</h3>
                        </div>
                    </div>
                    <div class="cssTree">
                        <asp:TreeView ID="treemenu" NodeWrap="True" runat="server" Style="margin-top: 10px;" CssClass="tree_menu" OnSelectedNodeChanged="treemenu_SelectedNodeChanged">
                            <NodeStyle ImageUrl="../../UI/img/folder.gif" HorizontalPadding="3" Width="100%" CssClass=""
                                VerticalPadding="3px" />
                            <ParentNodeStyle ImageUrl="../../UI/img/root.gif" />
                            <RootNodeStyle ImageUrl="../../UI/img/root.gif" />
                            <SelectedNodeStyle Font-Bold="True" />
                        </asp:TreeView>
                    </div>
                    <div id="DaCap_Info">
                        <div class="button" style="margin-bottom: 10px;">
                            <asp:Button ID="cmdThem_DaCap" runat="server" CssClass="buttoninput" Text="Thêm mới" OnClick="btnThem_DaCap_Click" />

                        </div>


                        <div class="clear"></div>
                        <div class="lbTitle">Tên<asp:Label runat="server" ID="Label2" Text="(*)" ForeColor="Red"></asp:Label></div>
                        <div class="inputData">
                            <asp:TextBox ID="txtTen_DaCap" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle">Mã<asp:Label runat="server" ID="Label4" Text="(*)" ForeColor="Red"></asp:Label></div>
                        <div class="inputData">
                            <asp:TextBox ID="txtMa_DaCap" CssClass="user" runat="server" Width="32%" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle">Dữ liệu cấp cha</div>
                        <div class="inputData">
                            <asp:DropDownList CssClass="chosen-select" ID="dropDuLieu_CapCha" runat="server" Style="width: 102%;">
                            </asp:DropDownList>
                        </div>
                        <div class="clear"></div>
                        <div class="lbTitle">Ghi chú</div>
                        <div class="inputData">
                            <asp:TextBox ID="txtGhiChu_DaCap" CssClass="user" runat="server" Width="100%" MaxLength="250"></asp:TextBox>
                        </div>
                        <div class="clear"></div>

                        <div class="lbTitle">Thứ tự</div>
                        <div class="inputData">
                            <asp:TextBox ID="txtThuTu_DaCap" CssClass="user" runat="server" Width="12%" MaxLength="3"></asp:TextBox>
                        </div>

                        <div class="clear"></div>
                        <div class="lbTitle">Trạng thái</div>
                        <div class="inputData" style="width: 2%;">
                            <asp:CheckBox ID="chkTrangThai_DaCap" runat="server" />
                        </div>
                        <div class="clear"></div>


                        <div class="lbTitle"></div>
                        <div class="inputData">
                            <div class="bt" style="margin-top: 8px; float: left; margin-right: 10px;">
                                <asp:Button ID="cmdUpdate_DaCap" runat="server" CssClass="buttoninput" Text="Lưu" OnClientClick="return Valid_DaCap()" OnClick="btnUpdate_DaCap_Click" />
                                <asp:Button ID="cmdXoa_DaCap" runat="server" CssClass="buttoninput" Text="Xóa" OnClick="btnXoa_DaCap_Click" />
                                <asp:Button ID="cmdLamMoi_DaCap" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="btnLamMoi_DaCap_Click" />


                            </div>
                            <div style="margin-top: 15px;">
                                <asp:Label runat="server" ID="lbthongbao_DaCap" ForeColor="Red" Text=""></asp:Label>
                            </div>
                        </div>
                        <div class="clear"></div>
                    </div>
                </asp:Panel>
                <asp:Panel ID="pnlDataTable" runat="server">
                    <div class="head_panelDaCap">
                        <asp:TextBox runat="server" ID="txtTimKiem" Width="17%" CssClass="user inputSearch" placeholder="Mã, tên dữ liệu"></asp:TextBox>
                        <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" CausesValidation="false" Text="Tìm kiếm" OnClick="Btntimkiem_Click" />

                    </div>
                    <div class="phantrang" id="PhanTrang_T" runat="server" style="float: left; width: 100%;">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbTStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                    <asp:Repeater ID="rpt" runat="server" OnItemCommand="rpt_ItemCommand" >
                        <HeaderTemplate>
                            <table style="width: 100%;" class="table2">
                                <tr class="header">
                                    <td  style="width: 35px;">STT</td>
                                    <td  style="width: 60px;">Mã</td>
                                    <td >Tên</td>
                                      <td style="width: 35px; text-align: center;">DS</td>
                                    <td style="width: 35px; text-align: center;">HC</td>
                                    <td style="width: 35px; text-align: center;">HNGĐ</td>
                                    <td style="width: 35px; text-align: center;">KDTM</td>
                                    <td style="width: 35px; text-align: center;">LĐ</td>
                                    <td style="width: 35px; text-align: center;">PS</td>
                                    <td style="width: 35px; text-align: center;">XLHC</td>
                                    <td style="width: 35px; text-align: center;">HS</td>
                                    <td  style="width: 60px;">Trạng thái</td>
                                    <td  style="width: 70px;">Thao tác</td>
                                </tr>
                        </HeaderTemplate>
                        <ItemTemplate>
                            <tr>
                                <td><%#Eval("TT")%></td>
                                <td><%#Eval("MA")%></td>
                                <td><%#Eval("Ten")%></td>

                                <td style="text-align: center;"><%#Eval("IsDanSu")%></td>
                                <td style="text-align: center;"><%#Eval("IsHanhChinh")%></td>
                                <td style="text-align: center;"><%#Eval("IsHNGD")%></td>

                                <td style="text-align: center;"><%#Eval("IsKDTM")%></td>
                                <td style="text-align: center;"><%#Eval("IsLaoDong")%></td>
                                <td style="text-align: center;"><%#Eval("IsPhaSan")%></td>

                                <td style="text-align: center;"><%#Eval("IsBPXLHC")%></td>
                                <td style="text-align: center;"><%#Eval("IsHinhSu")%></td>

                                <td><%#(Convert.ToInt16(Eval("HIEULUC"))==1)?"Sử dụng":"Chưa sử dụng" %></td>
                                <td>
                                    <asp:LinkButton ID="lbtSua" runat="server" Text="Sửa" CausesValidation="false" CommandName="Sua" ForeColor="#0e7eee"
                                        CommandArgument='<%#Eval("ID") %>'></asp:LinkButton>
                                    &nbsp;&nbsp;<asp:LinkButton ID="lbtXoa" runat="server" CausesValidation="false" Text="Xóa" ForeColor="#0e7eee"
                                        CommandName="Xoa" CommandArgument='<%#Eval("ID") %>' ToolTip="Xóa" OnClientClick="return confirm('Bạn thực sự muốn xóa dữ liệu danh mục này? ');"></asp:LinkButton></td>
                            </tr>
                        </ItemTemplate>
                        <FooterTemplate></table></FooterTemplate>
                    </asp:Repeater>
                    <div class="phantrang" id="PhanTrang_D" runat="server">
                        <div class="sobanghi">
                            <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                        </div>
                        <div class="sotrang">
                            <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false" CssClass="back"
                                OnClick="lbTBack_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false" CssClass="active"
                                Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep1" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so"
                                Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so"
                                Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so"
                                Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so"
                                Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                            <asp:Label ID="lbBStep6" runat="server" Text="..."></asp:Label>
                            <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so"
                                Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                            <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next"
                                OnClick="lbTNext_Click"></asp:LinkButton>
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </div>
    </div>
    <asp:HiddenField ID="hddid" runat="server" Value="0" />
    <asp:HiddenField ID="hddParentID" runat="server" Value="0" />
    <script type="text/javascript">
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }
        function KtratenDV() {
            var txtTenDonCap = document.getElementById('<%=txtTen_DonCap.ClientID %>')
            var txtMaDonCap = document.getElementById('<%=txtMa_DonCap.ClientID %>')
            var txtGhiChuDonCap = document.getElementById('<%=txtGhiChu_DonCap.ClientID %>')
            var txtThuTuDonCap = document.getElementById('<%=txtThuTu_DonCap.ClientID %>')

            if (txtTenDonCap.value.trim() == null || txtTenDonCap.value.trim() == "") {
                alert('Bạn hãy nhập tên dữ liệu danh mục!');
                txtTenDonCap.focus();
                return false;
            }
            if (txtMaDonCap.value.trim() == null || txtMaDonCap.value.trim() == "") {
                alert('Bạn hãy nhập mã dữ liệu danh mục!');
                txtMaDonCap.focus();
                return false;
            } else {
                if (txtMaDonCap.value.lenght > 250) {
                    alert('Mã dữ liệu danh mục không quá 250 ký tự!');
                    txtMaDonCap.focus();
                    return false;
                }
            }

            if (txtGhiChuDonCap.value.lenght > 250) {
                alert('Ghi chú dữ liệu danh mục không quá 250 ký tự!');
                txtGhiChuDonCap.focus();
                return false;
            }
            var filter = /^([0-9]{0,3})+$/;
            if (!filter.test(txtThuTuDonCap.value)) {
                alert('Bạn phải nhập thứ tự kiểu số, và độ dài từ 0-3 ký tự.');
                txtThuTuDonCap.focus; return false;
            }
            return true;
        }
        function Valid_DaCap() {
            var txtTenDaCap = document.getElementById('<%=txtTen_DaCap.ClientID %>')
            var txtMaDaCap = document.getElementById('<%=txtMa_DaCap.ClientID %>')
            var txtGhiChuDaCap = document.getElementById('<%=txtGhiChu_DaCap.ClientID %>')
            var txtThuTuDaCap = document.getElementById('<%=txtThuTu_DaCap.ClientID %>')

            if (txtTenDaCap.value.trim() == null || txtTenDaCap.value.trim() == "") {
                alert('Bạn hãy nhập tên dữ liệu danh mục!');
                txtTenDaCap.focus();
                return false;
            }

            if (txtMaDaCap.value.trim() == null || txtMaDaCap.value.trim() == "") {
                alert('Bạn hãy nhập mã dữ liệu danh mục!');
                txtMaDaCap.focus();
                return false;
            } else {
                if (txtMaDaCap.value.lenght > 250) {
                    alert('Mã dữ liệu danh mục không quá 250 ký tự!');
                    txtMaDaCap.focus();
                    return false;
                }
            }

            if (txtGhiChuDaCap.value.lenght > 250) {
                alert('Ghi chú dữ liệu danh mục không quá 250 ký tự!');
                txtGhiChuDaCap.focus();
                return false;
            }
            var filter = /^([0-9]{0,3})+$/;
            if (!filter.test(txtThuTuDaCap.value)) {
                alert('Bạn phải nhập thứ tự kiểu số, và độ dài từ 0-3 ký tự.');
                txtThuTuDaCap.focus; return false;
            }
            return true;
        }
    </script>
</asp:Content>
