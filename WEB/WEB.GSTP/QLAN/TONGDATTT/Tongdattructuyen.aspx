<%@ Page Title="" Language="C#" MasterPageFile="~/MasterPages/GSTP.Master" AutoEventWireup="true" CodeBehind="Tongdattructuyen.aspx.cs" Inherits="WEB.GSTP.QLAN.TONGDATTT.Tongdattructuyen" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:HiddenField ID="hddTotalPage" Value="1" runat="server" />
    <asp:HiddenField ID="hddPageIndex" Value="1" runat="server" />
    <div class="box">
        <div class="box_nd">
            <div class="truong">
                <table class="table1">
                    <tr>
                        <td colspan="2">
                            <div class="boxchung">
                                <h4 class="tleboxchung">Tìm kiếm</h4>
                                <div class="boder" style="padding: 10px;">
                                    <table class="table1">
                                        <tr>
                                            <td>
                                                <div style="float: left; width: 1050px">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Loại án</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlLoaiAn" CssClass="chosen-select" runat="server" Width="248px" AutoPostBack="True" OnSelectedIndexChanged="ddlLoaiAn_SelectedIndexChanged">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên vụ án</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTenVuViec" CssClass="user" runat="server" Width="240px"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tên Văn bản</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="Drop_VanBANTD" CssClass="chosen-select" runat="server" Width="248px">
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Số Văn bản </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtSoQD" CssClass="user" runat="server" Width="70px"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Ngày Văn bản</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NgayQD" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender4" runat="server" TargetControlID="txt_NgayQD" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender5" runat="server" TargetControlID="txt_NgayQD" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator5" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NgayQD" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    
                                                </div>

                                                 <div style="float: left; width: 1050px; margin-top: 8px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Trạng thái tống đạt</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTrangThaiTD" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Chờ tống đạt"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Đã tống đạt"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Hình thức tống đạt</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="dropHinhthucTD" CssClass="chosen-select" runat="server" Width="250px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Trực tuyến"></asp:ListItem>
                                                            <asp:ListItem Value="0" Text="Trực tiếp"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Qua bưu điện"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>

                                                    
                                                </div>

                                                 <div style="float: left; width: 1050px; margin-top: 6px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Bị can /Bị cáo/ Đương sự</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtBiCan" CssClass="user" runat="server" Width="240px" MaxLength="50"></asp:TextBox>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Thư ký</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlHTND_Thuky" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Thẩm phán</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="ddlThamphan" CssClass="chosen-select" runat="server" Width="250px"></asp:DropDownList>
                                                        <asp:HiddenField ID="hddLoaiTK" runat="server" Value="" />
                                                    </div>

                                                </div>
                                               <asp:Panel runat="server" ID="pnKetQua" Visible="false">
                                                <div style="float: left; width: 1050px; margin-top: 4px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTINHTRANG_THULY" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="Đã thụ lý"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text="Chưa thụ lý"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_TU" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txt_NGAYTHULY_TU" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender3" runat="server" TargetControlID="txt_NGAYTHULY_TU" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator3" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_TU" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txt_NGAYTHULY_DEN" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender3" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender4" runat="server" TargetControlID="txt_NGAYTHULY_DEN" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator4" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txt_NGAYTHULY_DEN" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 65px; text-align: right; margin-right: 10px;">Số Thụ lý</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtThuly_So" CssClass="user" runat="server" Width="242px"></asp:TextBox>
                                                    </div>
                                                </div>
                                                <div style="float: left; width: 1050px; margin-top: 2px;">
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Tình trạng GQ</div>
                                                    <div style="float: left;">
                                                        <asp:DropDownList ID="DropTINHTRANG_GIAIQUYET" CssClass="chosen-select" runat="server" Width="248px">
                                                            <asp:ListItem Value="" Text="-- Tất cả --"></asp:ListItem>
                                                            <asp:ListItem Value="1" Text="+ Chưa giải quyết xong"></asp:ListItem>
                                                            <asp:ListItem Value="2" Text=".....Chưa phân công Thẩm phán"></asp:ListItem>
                                                            <asp:ListItem Value="3" Text=".....Đã phân công Thẩm phán"></asp:ListItem>
                                                            <asp:ListItem Value="4" Text=".....Đã lên lịch xét xử"></asp:ListItem>
                                                            <asp:ListItem Value="5" Text=".....Đang hoãn"></asp:ListItem>
                                                            <asp:ListItem Value="6" Text=".....Đang tạm đình chỉ"></asp:ListItem>
                                                            <asp:ListItem Value="7" Text="+ Đã giải quyết xong"></asp:ListItem>
                                                            <asp:ListItem Value="8" Text=".....Đã xét xử"></asp:ListItem>
                                                            <asp:ListItem Value="9" Text=".....Đình chỉ"></asp:ListItem>
                                                            <asp:ListItem Value="10" Text=".....Chuyển vụ án"></asp:ListItem>
                                                        </asp:DropDownList>
                                                    </div>
                                                    <div style="float: left; width: 80px; text-align: right; margin-right: 10px;">Từ ngày </div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtTuNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="txtTuNgay_CalendarExtender" runat="server" TargetControlID="txtTuNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server" TargetControlID="txtTuNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtTuNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    <div style="float: left; width: 75px; text-align: center;">Đến ngày</div>
                                                    <div style="float: left;">
                                                        <asp:TextBox ID="txtDenNgay" runat="server" CssClass="user" Width="70px" MaxLength="10"></asp:TextBox>
                                                        <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtDenNgay" Format="dd/MM/yyyy" Enabled="true" />
                                                        <cc1:MaskedEditExtender ID="MaskedEditExtender2" runat="server" TargetControlID="txtDenNgay" Mask="99/99/9999" MaskType="Date" CultureName="vi-VN" ErrorTooltipEnabled="true" />
                                                        <cc1:MaskedEditValidator ID="MaskedEditValidator2" runat="server" ControlExtender="MaskedEditExtender1" ControlToValidate="txtDenNgay" InvalidValueMessage="dd/MM/yyyy" Style="color: red; margin-left: 15px;"></cc1:MaskedEditValidator>
                                                    </div>
                                                    
                                                </div>
                                               </asp:Panel>
                                               
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </td>
                    </tr>

                    <tr>
                        
                        <td align="center" colspan="2">
                            <div style="float: left; width: 1050px; margin-top: 8px;">
                                
                                    <asp:Button ID="cmdTimkiem" runat="server" CssClass="buttoninput" Text="Tìm kiếm" OnClick="lbtimkiem_Click" />
                                    <asp:Button ID="cmdLammoi" runat="server" CssClass="buttoninput" Text="Làm mới" OnClick="cmdLammoi_Click" />
                                
                                <div style="float: right; margin-left: 9px; margin-right: 2px;">
                                    <asp:Button ID="btn_baocao" OnClick="btn_baocao_Click" runat="server" Width="100px" CssClass="buttonprint" Text="Báo cáo" />
                                </div>
                                <div style="float: right; margin-right: 50px;">
                                    <asp:Label runat="server" ID="lbtthongbao" ForeColor="Red" Font-Size="17px"></asp:Label>
                                </div>
                            </div>
                        </td>
                    </tr>
                    
                    <tr>
                        <td colspan="2" align="left">
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiT" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbTBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTFirst" runat="server" CausesValidation="false" CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbTStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbTLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbTNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                            <div>
                                <asp:DataGrid ID="dgList" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                    PageSize="20" AllowPaging="true" GridLines="None" PagerStyle-Mode="NumericPages"
                                    CssClass="table2" HeaderStyle-CssClass="header" AlternatingItemStyle-CssClass="le"
                                    ItemStyle-CssClass="chan" Width="100%"
                                    OnItemCommand="dgList_ItemCommand" OnItemDataBound="dgList_ItemDataBound">
                                    <Columns>
                                        <asp:BoundColumn DataField="ID" Visible="false"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="15px" ItemStyle-HorizontalAlign="Center" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate>STT</HeaderTemplate>
                                            <ItemTemplate><%#Eval("STT")%></ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TENBM" HeaderText="Tên Văn bản"
                                            HeaderStyle-Width="200px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="TenVuAn" HeaderText="Tên Vụ việc"
                                            HeaderStyle-Width="150px" ItemStyle-HorizontalAlign="left"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:BoundColumn DataField="LOAI_AN_TEN" HeaderText="Loại án"
                                            HeaderStyle-Width="70px" ItemStyle-HorizontalAlign="center"
                                            HeaderStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        
                                        <asp:TemplateColumn HeaderStyle-Width="100px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate> Người nhận </HeaderTemplate>
                                            <ItemTemplate> <%#Eval("NGUOINHAN")%> </ItemTemplate>
                                        </asp:TemplateColumn>
                                        <asp:BoundColumn DataField="TINHTRANGNHANVB" HeaderText="Đã nhận/ Đã gửi" 
                                            HeaderStyle-Width="104px" HeaderStyle-HorizontalAlign="Center" 
                                            ItemStyle-HorizontalAlign="Center"></asp:BoundColumn>
                                        <asp:TemplateColumn HeaderStyle-Width="60px" HeaderStyle-HorizontalAlign="Center">
                                            <HeaderTemplate> Trạng thái </HeaderTemplate>
                                            <ItemTemplate>
                                                <asp:LinkButton ID="cmdQLTONGDAT" runat="server" Text="Tống Đạt" ForeColor="#0e7eee"
                                                    CausesValidation="false" CommandName="QLTONGDAT"
                                                    CommandArgument='<%#Eval("ID")+ ","+ Eval("Loaian")+ ","+ Eval("DONID") + ","+ Eval("BIEUMAUID")%>'></asp:LinkButton>
                                               
                                            </ItemTemplate>
                                            <HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                        </asp:TemplateColumn>
                                    </Columns>
                                    <PagerStyle BackColor="#2461BF" ForeColor="White" HorizontalAlign="Center" Visible="false"></PagerStyle>
                                    <SelectedItemStyle BackColor="#D1DDF1" Font-Bold="True" ForeColor="#333333" />
                                </asp:DataGrid>
                            </div>
                            <div class="phantrang">
                                <div class="sobanghi">
                                    <asp:Literal ID="lstSobanghiB" runat="server"></asp:Literal>
                                </div>
                                <div class="sotrang">
                                    <asp:LinkButton ID="lbBBack" runat="server" CausesValidation="false"
                                        CssClass="back" Visible="true"
                                        OnClick="lbTBack_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBFirst" runat="server" CausesValidation="false"
                                        CssClass="active" Visible="false"
                                        Text="1" OnClick="lbTFirst_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep1" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBStep2" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="2" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep3" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="3" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep4" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="4" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBStep5" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="5" OnClick="lbTStep_Click"></asp:LinkButton>
                                    <asp:Label ID="lbBStep6" runat="server" Text="..." Visible="false"></asp:Label>
                                    <asp:LinkButton ID="lbBLast" runat="server" CausesValidation="false" CssClass="so" Visible="false"
                                        Text="100" OnClick="lbTLast_Click"></asp:LinkButton>
                                    <asp:LinkButton ID="lbBNext" runat="server" CausesValidation="false" CssClass="next" Visible="false"
                                        OnClick="lbTNext_Click"></asp:LinkButton>
                                    <asp:DropDownList ID="dropPageSize2" runat="server" Width="55px" CssClass="so"
                                        AutoPostBack="True" OnSelectedIndexChanged="dropPageSize2_SelectedIndexChanged">
                                        <asp:ListItem Value="10" Text="10"></asp:ListItem>
                                        <asp:ListItem Value="20" Text="20" Selected="True"></asp:ListItem>
                                        <asp:ListItem Value="30" Text="30"></asp:ListItem>
                                        <asp:ListItem Value="50" Text="50"></asp:ListItem>
                                        <asp:ListItem Value="100" Text="100"></asp:ListItem>
                                        <asp:ListItem Value="200" Text="200"></asp:ListItem>
                                        <asp:ListItem Value="500" Text="500"></asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                            </div>
                        </td>
                    </tr>

                </table>
            </div>
        </div>
    </div>
    <script>
        function pageLoad(sender, args) {
            var config = { '.chosen-select': {}, '.chosen-select-deselect': { allow_single_deselect: true }, '.chosen-select-no-single': { disable_search_threshold: 10 }, '.chosen-select-no-results': { no_results_text: 'Oops, nothing found!' }, '.chosen-select-rtl': { rtl: true }, '.chosen-select-width': { width: '95%' } }
            for (var selector in config) { $(selector).chosen(config[selector]); }
        }
    </script>
</asp:Content>
