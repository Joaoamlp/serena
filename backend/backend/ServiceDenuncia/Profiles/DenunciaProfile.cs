using AutoMapper;
using DominioDenuncia;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ServiceDenuncia;


namespace ServiceDenuncia.Profiles
{
    public class DenunciaProfile : Profile
    {
        public DenunciaProfile()
        {
            // Endereço
            CreateMap<EnderecoDto, Endereco>().ReverseMap();

            // Create → Entity
            CreateMap<DenunciaCreateDto, Denuncia>()
                .ForMember(dest => dest.CriadoEm,
                    opt => opt.MapFrom(_ => DateTime.UtcNow))
                .ForMember(dest => dest.Status,
                    opt => opt.MapFrom(_ => DenunciaStatus.Nova))
                .ForMember(dest => dest.TipoViolencia,
                    opt => opt.MapFrom(src =>
                        Enum.Parse<TipoViolencia>(src.TipoViolencia, true)));

            // Entity → DTO
            CreateMap<Denuncia, DenunciaDto>()
                .ForMember(dest => dest.Status,
                    opt => opt.MapFrom(src => src.Status.ToString()))
                .ForMember(dest => dest.TipoViolencia,
                    opt => opt.MapFrom(src => src.TipoViolencia.ToString()));

        }
    }
}
